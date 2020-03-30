class Types::ProductType < Types::BaseObject
  field :name, String, null: false
  field :color, String, null: true
  field :size, String, null: true
  field :price_cents, Integer, null: false
  field :category, Types::CategoryType, null: false
  field :orders, [Types::OrderType], null: false

  def price_cents
    (100 * object.price).to_i
  end
end
