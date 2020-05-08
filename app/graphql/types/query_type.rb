class Types::QueryType < Types::BaseObject
  field_categories
  field_products
  field_users
  field_orders

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
