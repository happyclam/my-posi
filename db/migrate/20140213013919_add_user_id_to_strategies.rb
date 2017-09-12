class AddUserIdToStrategies < ActiveRecord::Migration
  def self.up
    add_column(:strategies, :user_id, :integer)
    add_index(:strategies, :user_id)
  end
  def self.down
    remove_index(:strategies, :column => :user_id)
    remove_colun(:strategies, :user_id)
  end

end
