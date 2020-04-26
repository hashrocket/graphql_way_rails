class Types::QueryType < Types::BaseObject
  categories_field
  products_field
  users_field
  orders_field

  def categories(**query_options)
    Category.graphql_query(query_options)
  end

  def products(**query_options)
    Product.graphql_query(query_options)
  end

  def users(**query_options)
    User.graphql_query(query_options)
  end

  def orders(**query_options)
    Order.graphql_query(query_options)
  end
end
