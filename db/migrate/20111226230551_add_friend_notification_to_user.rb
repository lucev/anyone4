class AddFriendNotificationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :friend_notification, :boolean, :default => true
    add_column :users, :activity_notification, :boolean, :default => true
    add_column :users, :comment_notification, :boolean, :default => true
  end

  def self.down
    remove_column :users, :friend_notification
    remove_column :users, :activity_notification
    remove_column :users, :comment_notification
  end
end
