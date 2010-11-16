class Activity < ActiveRecord::Base
  attr_accessible :title
  
  belongs_to :user
  
  validates :title, :presence => true, :length => { :maximum => 60 }
  validates :user_id, :presence => true
  
  default_scope :order => 'activities.created_at DESC'

end
