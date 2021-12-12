class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.string :number
      t.datetime :created_month
      t.integer :supplier_id
      t.datetime :issued_at
      t.string :supplier_name
      t.datetime :sent_at
      t.datetime :planned_delivery
      t.datetime :actual_delivery
      t.string :user
      t.string :note
      t.string :state
      t.decimal :price_without_vat
      t.decimal :price_with_vat

      t.timestamps
    end
  end
end
