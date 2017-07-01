class User < ApplicationRecord

  def has_time_remaining
    (self.active && self.expiration > Time.now.to_i) || (!self.active && self.countdown > 0)
  end

  def in_active_window
    true
  end

  def is_correct_day
    self.today == Date.today
  end

  def good_to_go
    is_correct_day && in_active_window && has_time_remaining
  end

  def update_countdown
    self.countdown = self.expiration - Time.now.to_i
    self.countdown = 0 if self.countdown < 0
    self.save
  end

  def update_expiration
    self.expiration = Time.now.to_i + self.countdown
  end

  def start_internet
    update_expiration

    echo_cmd = "./macaddr on #{self.mac_address} #{Time.at(self.expiration).utc.strftime('%FT%T')}"
    puts echo_cmd
    result = `#{echo_cmd}`
    raise "cannot add permission to firewall" unless result.rstrip.end_with?('result: 0')

    self.save
  end

  def stop_internet
    # remove any lingering firewall rule
    echo_cmd = "./macaddr off #{self.mac_address} #{Time.at(self.expiration).utc.strftime('%FT%T')}"
    puts echo_cmd
    puts `#{echo_cmd}`

    update_countdown
  end

  def reset_day
    self.today = Date.today
    self.countdown = self.minutes_per_day * 60
    self.save
  end

  def update_properties
    if self.active
      if self.expiration <= Time.now.to_i
        update_active_state(false)
      else
        update_countdown
      end
    else
      reset_day unless is_correct_day
    end
  end

  def update_active_state(new_active_status)
    old_active_status = self.active
    if good_to_go
      self.active = new_active_status
    else
      self.active = false
    end

    if old_active_status
      if new_active_status
        update_countdown
      else
        stop_internet
      end
    elsif new_active_status
      # go_active if active state has changed to true
      start_internet
    end
  end
end
