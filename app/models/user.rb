class User < ApplicationRecord
  def self.update_countdown
	  User.where(active: true).each do |user|
	    if user.countdown > 0
	      user.countdown = user.countdown - 60 
	      user.save
	    end
	    if user.countdown <= 0
	      user.active = false
	      user.save
	    end
	  end
  end
end
