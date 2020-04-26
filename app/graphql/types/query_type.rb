class Types::QueryType < Types::BaseObject
  categories_field
  products_field
  users_field
  orders_field

  def categories(name: nil, sort: nil, limit: nil)
    Category.graphql_query(
      name: name,
      sort: sort,
      limit: limit
    )
  end

  def products(name: nil, color: nil, size: nil, min_price: nil, max_price: nil, sort: nil, limit: nil)
    Product.graphql_query(
      name: name,
      color: color,
      size: size,
      min_price: min_price,
      max_price: max_price,
      sort: sort,
      limit: limit
    )
  end

  def users(email: nil, sort: nil, limit: nil)
    User.graphql_query(
      email: email,
      sort: sort,
      limit: limit
    )
  end

  def orders(min_ordered_at: nil, max_ordered_at: nil, sort: nil, limit: nil)
    Order.graphql_query(
      min_ordered_at: min_ordered_at,
      max_ordered_at: max_ordered_at,
      sort: sort,
      limit: limit
    )
  end
end
