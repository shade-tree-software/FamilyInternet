class User < ApplicationRecord

  def has_time_remaining
    (self.active && self.expiration > Time.now.to_i) || (!self.active && self.countdown > 0)
  end

  def in_active_window
    Time.now.between? Time.parse(self.wakeup), Time.parse(self.bedtime)
  end

  def is_correct_day
    self.today == Date.today
  end

  def good_to_go
    is_correct_day && in_active_window && has_time_remaining
  end

  def seconds_until_bedtime
    res = in_active_window ? Time.parse(self.bedtime) - Time.now : 0
    res >= 0 ? res : 0
  end

  def generate_new_countdown
    # this should be used only when active, because
    # that's the only time we can trust the expiration
    self.countdown = self.expiration - Time.now.to_i
    self.countdown = 0 if self.countdown < 0
  end

  def generate_new_expiration
    # this should be used only when not active, because
    # that's the only time we can trust the countdown
    self.expiration = Time.now.to_i + [self.countdown, seconds_until_bedtime].min
  end

  def firewall(command)
    if command == :allow_user
      echo_cmd = "./macaddr on #{self.username} #{self.mac_address} #{Time.at(self.expiration).utc.strftime('%FT%T')}"
      puts echo_cmd
      result = `#{echo_cmd}`
      raise "cannot add permission to firewall" unless result.rstrip.end_with?('result: 0')
    else
      echo_cmd = "./macaddr off #{self.username} #{self.mac_address} #{Time.at(self.expiration).utc.strftime('%FT%T')}"
      puts echo_cmd
      puts `#{echo_cmd}`
    end
  end

  def start_internet
    self.active = true
    generate_new_expiration
    firewall :allow_user
  end

  def stop_internet
    self.active = false
    firewall :disallow_user
    generate_new_countdown
  end

  def adjust_countdown
    if in_active_window && !is_correct_day
      self.today = Date.today
      self.countdown = self.minutes_per_day * 60
    end
    self.countdown = [self.countdown, seconds_until_bedtime].min
  end

  def update_properties
    if self.active
      (self.expiration <= Time.now.to_i) ? stop_internet : generate_new_countdown
    else
      adjust_countdown
    end
    self.save
  end

  def update_internet_state(go_active)
    if !self.active && go_active
      start_internet
      self.save
    elsif self.active && !go_active
      stop_internet
      self.save
    end
  end
end
