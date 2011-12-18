class Activity < ActiveRecord::Base
  attr_accessible :title, :location, :description, :starts_at, :ends_at

  belongs_to :user
  has_many :participations, :dependent => :destroy
  has_many :participants, :through => :participations, :source => :user
  has_many :comments, :dependent => :destroy

  validates :title, :presence => true, :length => { :maximum => 60 }
  validates :user_id, :presence => true

  default_scope :order => 'activities.created_at DESC'

  scope :from_friends, lambda { |user| from_friends(user)}

  def attending? user
    if user.nil?
      return false
    end
    if self.participants.find_by_id(user.id)
      return true
    else
      return false
    end
  end

  def owner
    user = User.find_by_id(self.user_id)
    return user
  end

  def owner? (user)
    self.user_id == user.id ? true : false
  end

  private
   
    def self.from_friends(user)
      friend_ids = %(SELECT DISTINCT friend_id FROM friendships
                       WHERE user_id = :user_id)
      reverse_friend_ids = %(SELECT DISTINCT user_id FROM friendships
                       WHERE friend_id = :user_id)
      where("user_id IN (#{friend_ids}) OR user_id IN (#{reverse_friend_ids}) OR user_id = :user_id",
        { :user_id => user}
      )
    end
end
