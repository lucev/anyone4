class Comment < ActiveRecord::Base
  attr_accessible :content, :activity_id

  belongs_to :activity
  belongs_to :user

  def author
    user = User.find_by_id(self.user_id)
    return  user
  end


end

