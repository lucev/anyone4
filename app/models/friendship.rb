class Friendship < ActiveRecord::Base
  attr_accessible :user_id, :friend_id
  
  belongs_to :user, :class_name => "User"
  belongs_to :friend, :class_name => "User"
  
  scope :including, lambda {|user| including(user)}
  
  before_save :notify
  
  private
    def self.including(user)
      user_ids = %(SELECT DISTINCT friend_id FROM friendships
                       WHERE user_id = :user_id)
      friend_ids = %(SELECT DISTINCT user_id FROM friendships
                       WHERE friend_id = :user_id)
      where("user_id IN (#{user_ids}) OR user_id IN (#{friend_ids}) OR user_id = :user_id",
        { :user_id => user}
      )      
    end
    
    def notify
      UserMailer.friendship_request(self.friend, self.user).deliver if
        self.friend.friend_notification
    end
end
