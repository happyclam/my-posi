class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.string :name
      t.integer :draw_type
      t.integer :range
      t.float :interest, {default: 0.02}
      t.float :sigma, {default:nil}

      t.timestamps
    end
  end
end
