class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color
      t.string :size
      t.decimal :price, precision: 8, scale: 2, null: false

      t.timestamps
    end
  end
end
