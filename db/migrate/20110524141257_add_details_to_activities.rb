class AddDetailsToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :desctiption, :string
    add_column :activities, :starts_at, :datetime
    add_column :activities, :ends_at, :datetime
  end

  def self.down
    remove_column :activities, :desctiption
    remove_column :activities, :starts_at
    remove_column :activities, :ends_at
  end
end

