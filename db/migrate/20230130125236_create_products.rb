class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false, limit: 255
      t.integer :price, null: false
      t.integer :average_period, default: 0
      t.integer :average_amount_per_day, default: 0

      t.timestamps
    end
  end
end
