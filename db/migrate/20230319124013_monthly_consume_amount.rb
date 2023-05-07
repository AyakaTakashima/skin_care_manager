class MonthlyConsumeAmount < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_consume_amounts do |t|
      t.references :product, null: false, foreign_key: true
      t.references :product_consume_log, null: false, foreign_key: true
      t.date :month, null: false
      t.integer :amount, default: 30

      t.timestamps
    end
  end
end
