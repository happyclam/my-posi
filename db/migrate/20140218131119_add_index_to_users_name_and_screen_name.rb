class AddIndexToUsersNameAndScreenName < ActiveRecord::Migration
  def change
    add_index :users, :name, unique: true
    add_index :users, :screen_name, unique: true
  end
end
