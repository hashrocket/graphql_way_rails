class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :ordered_at, null: false

      t.timestamps
    end
  end
end
