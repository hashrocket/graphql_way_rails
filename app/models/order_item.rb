class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def self.graphql_query(options)
    query = OrderItem.all

    if options[:order]
      order_query = Order.graphql_query(options[:order])
      query = query.joins(:order).merge(order_query)
    end

    if options[:product]
      product_query = Product.graphql_query(options[:product])
      query = query.joins(:product).merge(product_query)
    end

    query
  end
end
