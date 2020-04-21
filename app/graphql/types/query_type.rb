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

  def products(name: nil, color: nil, size: nil, minPrice: nil, maxPrice: nil, sort: nil, limit: nil)
    Product.graphql_query(
      name: name,
      color: color,
      size: size,
      minPrice: minPrice,
      maxPrice: maxPrice,
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

  def orders(minOrderedAt: nil, maxOrderedAt: nil, sort: nil, limit: nil)
    Order.graphql_query(
      minOrderedAt: minOrderedAt,
      maxOrderedAt: maxOrderedAt,
      sort: sort,
      limit: limit
    )
  end
end
