# == Schema Information
# Schema version: 20101113162642
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  location   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :name, :email, :location, :password, :password_confirmation

  has_many :activities, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :participations, :dependent => :destroy
  has_many :attendances, :through => :participations, :source => :activity
  
  has_many :friendships, :dependent => :destroy, :conditions => ['confirmed = ?', true]
  has_many :friends, :through => :friendships
  
  has_many :friendship_requests, :dependent => :destroy, :conditions => ['confirmed = ?', false],
                                 :class_name => 'Friendship',
                                 :foreign_key => 'friend_id'
  
  has_many :reverse_friendships, :dependent => :destroy,
                                 :class_name => 'Friendship',
                                 :foreign_key => 'friend_id',
                                 :conditions => ['confirmed = ?', true]
                                 
  has_many :reverse_friends, :through => :reverse_friendships, :source => :user


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence   => true

#  validates :email, :presence   => true,
#                    :format     => { :with => email_regex },
#                    :uniqueness => { :case_sensitive => false }

#  validates :password, :presence     => true,
#                       :confirmation => true,
#                       :length       => { :within => 6..40 }


  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  def feed
    Activity.from_friends(self)
  end
  
  def friend_of? user
    self.friends.include? user or self.reverse_friends.include? user
  end
  
  def involving_friendships
    Friendship.including self
  end
  
  def contacts
    contacts = Array.new
    involving_friendships = self.involving_friendships
    involving_friendships.each do |friendship|
      if friendship.user_id == self.id
       contacts.push friendship.friend
      else
       contacts.push friendship.user
      end
    end
    return contacts
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

