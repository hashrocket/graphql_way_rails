class Types::QueryType < Types::BaseObject
  categories_field
  products_field
  users_field
  orders_field

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
