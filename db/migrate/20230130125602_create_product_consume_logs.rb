class CreateProductConsumeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :product_consume_logs do |t|
      t.references :product, null: false, foreign_key: true
      t.date :use_started_at, null: false
      t.date :use_ended_at

      t.timestamps
    end
  end
end
