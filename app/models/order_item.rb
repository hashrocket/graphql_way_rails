class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def self.graphql_query(order: nil, product: nil, joins: nil, sort: nil, limit: nil)
    query = OrderItem.all
      .joins(joins)
      .order(sort)
      .limit(limit)

    query = if order
      order_query = Order.graphql_query(
        minOrderedAt: order[:minOrderedAt],
        maxOrderedAt: order[:maxOrderedAt]
      )

      query.merge(order_query)
    else
      query
    end

    if product
      product_query = Product.graphql_query(
        name: product[:name],
        color: product[:color],
        size: product[:size],
        minPrice: product[:minPrice],
        maxPrice: product[:maxPrice],
        joins: product[:joins],
        sort: product[:sort],
        limit: product[:limit]
      )

      query.merge(product_query)
    else
      query
    end
  end
end
