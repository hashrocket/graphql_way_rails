class Types::QueryType < Types::BaseObject
  field :categories, [Types::CategoryType], null: false do
    sort_argument :name
    limit_argument
  end

  field :products, [Types::ProductType], null: false do
    sort_argument :name, :color, :size, :price
    limit_argument
  end

  field :users, [Types::UserType], null: false do
    sort_argument :email
    limit_argument
  end

  field :orders, [Types::OrderType], null: false do
    sort_argument :ordered_at
    limit_argument
  end

  def categories(sort: nil, limit: nil)
    query = Category
    query = query.order(sort) if sort
    query = query.limit(limit) if limit
    query
  end

  def products(sort: nil, limit: nil)
    query = Product
    query = query.order(sort) if sort
    query = query.limit(limit) if limit
    query
  end

  def users(sort: nil, limit: nil)
    query = User
    query = query.order(sort) if sort
    query = query.limit(limit) if limit
    query
  end

  def orders(sort: nil, limit: nil)
    query = Order
    query = query.order(sort) if sort
    query = query.limit(limit) if limit
    query
  end
end
