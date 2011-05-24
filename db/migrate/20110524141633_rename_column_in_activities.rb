class RenameColumnInActivities < ActiveRecord::Migration
  def self.up
    rename_column :activities, :desctiption, :description
  end

  def self.down
    rename_column :activities, :description, :desctiption
  end
end

