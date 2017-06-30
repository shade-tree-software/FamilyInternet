class User < ApplicationRecord

  def has_time_remaining
    (self.active && self.expiration > Time.now.to_i) || (!self.active && self.countdown > 0)
  end

  def go_inactive
    update_active_state(false)
  end

  def update_countdown
    self.countdown = self.expiration - Time.now.to_i
    self.countdown = 0 if self.countdown < 0
    self.save
  end

  def update_expiration
    self.expiration = Time.now.to_i + self.countdown
    self.save

    echo_cmd = "./macaddr on DC:EE:06:FE:52:82 #{Time.at(self.expiration).utc.strftime('%FT%T')}"
    puts echo_cmd
    puts `#{echo_cmd}`
  end

  def update_properties
    if self.expiration <= Time.now.to_i
      self.go_inactive
    else
      self.update_countdown
    end
  end

  def update_active_state(new_active_status)
    old_active_status = self.active
    if has_time_remaining
      self.active = new_active_status
    else
      self.active = false
    end

    if old_active_status
      # update countdown if we were active, regardless of what we are now
      self.update_countdown
    elsif new_active_status
      # update expiration if active state has changed to true
      self.update_expiration
    end
  end
end
