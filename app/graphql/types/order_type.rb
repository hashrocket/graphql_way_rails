class Types::OrderType < Types::BaseObject
  field :ordered_at, GraphQL::Types::ISO8601DateTime, null: false
  field :user, Types::UserType, null: false
  field :products, [Types::ProductType], null: false do
    sort_argument :name, :color, :size, :price
    limit_argument
  end

  def user
    Loaders::BelongsToLoader.for(User).load(object.user_id)
  end

  def products(sort: nil, limit: nil)
    sort = sort.map{ |k, v| ["products.#{k}", v] }.to_h

    order_items(joins: :product, sort: sort, limit: limit).then do |order_item_list|
      product_ids = order_item_list.map(&:product_id)
      Loaders::BelongsToLoader.for(Product).load_many(product_ids)
    end
  end

  private

  def order_items(*options)
    Loaders::HasManyLoader.for(OrderItem, :order_id, *options).load(object.id)
  end
end
