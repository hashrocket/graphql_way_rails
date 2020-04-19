class Types::QueryType < Types::BaseObject
  field :categories, [Types::CategoryType], null: false do
    limit_argument
  end

  field :products, [Types::ProductType], null: false do
    limit_argument
  end

  field :users, [Types::UserType], null: false do
    limit_argument
  end

  field :orders, [Types::OrderType], null: false do
    limit_argument
  end

  def categories(limit: nil)
    query = Category
    query = query.limit(limit) if limit
    query
  end

  def products(limit: nil)
    query = Product
    query = query.limit(limit) if limit
    query
  end

  def users(limit: nil)
    query = User
    query = query.limit(limit) if limit
    query
  end

  def orders(limit: nil)
    query = Order
    query = query.limit(limit) if limit
    query
  end
end
