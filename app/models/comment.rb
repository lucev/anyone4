class Comment < ActiveRecord::Base
  attr_accessible :content, :activity_id

  belongs_to :activity
  belongs_to :user
  
  after_save :notify

  def author
    user = User.find_by_id(self.user_id)
    return  user
  end
  
  private 
  
    def notify
      self.activity.participants.each do |user|
        if user.comment_notification and self.user != user
          UserMailer.comment_created(user, self).deliver
        end            
      end
      if self.user != self.activity.owner
        UserMailer.comment_created(self.activity.owner, self).deliver
      end
    end
end

