class Types::ProductType < Types::BaseObject
  field :name, String, null: false
  field :color, String, null: true
  field :size, String, null: true
  field :price_cents, Integer, null: false
  field :category, Types::CategoryType, null: false
  orders_field

  def category
    Loaders::BelongsToLoader
      .for(Category)
      .load(object.category_id)
  end

  def orders(min_ordered_at: nil, max_ordered_at: nil, sort: nil, limit: nil)
    query_options = {
      order: {
        min_ordered_at: min_ordered_at,
        max_ordered_at: max_ordered_at
      },
      joins: (sort || min_ordered_at || max_ordered_at) && :order,
      sort: sort,
      limit: limit
    }

    Loaders::HasManyLoader
      .for(OrderItem, :product_id, query_options)
      .load(object.id)
      .then do |order_items|
        order_ids = order_items.map(&:order_id)
        Loaders::BelongsToLoader
          .for(Order)
          .load_many(order_ids)
      end
  end

  def price_cents
    (100 * object.price).to_i
  end
end
