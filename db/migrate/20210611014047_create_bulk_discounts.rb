class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.integer :threshold
      t.integer :percent_discount
      t.references :merchant, foreign_key: true
      
      t.timestamps
    end
  end
end
