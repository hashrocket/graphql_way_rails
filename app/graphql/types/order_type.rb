class Types::OrderType < Types::BaseObject
  field :ordered_at, GraphQL::Types::ISO8601DateTime, null: false
  field :user, Types::UserType, null: false
  products_field

  def user
    Loaders::BelongsToLoader
      .for(User)
      .load(object.user_id)
  end

  def products(name: nil, color: nil, size: nil, min_price: nil, max_price: nil, sort: nil, limit: nil)
    query_options = {
      product: {
        name: name,
        color: color,
        size: size,
        min_price: min_price,
        max_price: max_price
      },
      joins: (sort || name || color || size || min_price || max_price) && :product,
      sort: sort,
      limit: limit
    }

    Loaders::HasManyLoader
      .for(OrderItem, :order_id, query_options)
      .load(object.id)
      .then do |order_items|
        product_ids = order_items.map(&:product_id)

        Loaders::BelongsToLoader
          .for(Product)
          .load_many(product_ids)
      end
  end
end
