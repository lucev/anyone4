class Activity < ActiveRecord::Base
  attr_accessible :title, :location, :description, :starts_at, :ends_at

  belongs_to :user
  has_many :participations
  has_many :participants, :through => :participations, :source => :user
  has_many :comments

  validates :title, :presence => true, :length => { :maximum => 60 }
  validates :user_id, :presence => true

  default_scope :order => 'activities.created_at DESC'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }

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

  private
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
            { :user_id => user })
    end

end

