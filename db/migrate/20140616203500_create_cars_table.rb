class CreateCarsTable < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.index :make_id
      t.integer :make_id
      t.string :color
      t.string :doors
      t.date :purchased_on
    end
  end
end
