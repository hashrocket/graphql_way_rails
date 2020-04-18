class Types::ProductType < Types::BaseObject
  field :name, String, null: false
  field :color, String, null: true
  field :size, String, null: true
  field :price_cents, Integer, null: false
  field :category, Types::CategoryType, null: false
  field :orders, [Types::OrderType], null: false

  def category
    Loaders::BelongsToLoader.for(Category).load(object.category_id)
  end

  def orders
    order_items.then do |order_item_list|
      order_ids = order_item_list.map(&:order_id)
      Loaders::BelongsToLoader.for(Order).load_many(order_ids)
    end
  end

  def price_cents
    (100 * object.price).to_i
  end

  private

  def order_items
    Loaders::HasManyLoader.for(OrderItem, :product_id).load(object.id)
  end
end
