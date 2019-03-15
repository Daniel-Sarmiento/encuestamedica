class Notification < ApplicationRecord
  belongs_to :user
  scope :unviewed, -> { where(visto: false) }

  def self.for_user(user_id)
  	Notification.where(user_id: user_id).unviewed
  end 

  
end
