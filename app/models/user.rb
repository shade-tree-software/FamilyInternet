class User < ApplicationRecord
  def self.update_countdown
	  User.where(active: true).each do |user|
	    if user.countdown > 0
	      new_countdown = user.countdown - 60
	      new_countdown = 0 if new_countdown < 0
	      user.countdown = new_countdown  
	      user.save
	    end
	    if user.countdown <= 0
	      user.countdown = 0 if user.countdown < 0
	      user.active = false
	      user.save
	    end
	  end
  end
end
