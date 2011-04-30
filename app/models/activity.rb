class Activity < ActiveRecord::Base
  attr_accessible :title

  belongs_to :user

  validates :title, :presence => true, :length => { :maximum => 60 }
  validates :user_id, :presence => true

  default_scope :order => 'activities.created_at DESC'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
            { :user_id => user })
    end

end

