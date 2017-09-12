class AddStrategyIdToPosition < ActiveRecord::Migration
  def self.up
    add_column(:positions, :strategy_id, :integer)
    add_index(:positions, :strategy_id)
  end
  def self.down
    remove_index(:positions, :column => :strategy_id)
    remove_column(:positions, :strategy_id)
  end
end
