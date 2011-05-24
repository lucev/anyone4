class AddLocationToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :location, :string
  end

  def self.down
    remove_column :activities, :location
  end
end

