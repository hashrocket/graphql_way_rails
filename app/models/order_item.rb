class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def self.graphql_query(options)
    if options[:order]
      order_options = options[:order].except(:sort, :limit)

      return graphql_query(options[:order].slice(:sort, :limit))
          .joins(:order)
          .merge(Order.graphql_query(order_options))
    end

    if options[:product]
      product_options = options[:product].except(:sort, :limit)

      return graphql_query(options[:product].slice(:sort, :limit))
          .joins(:product)
          .merge(Product.graphql_query(product_options))
    end

    OrderItem.all
      .order(options[:sort])
      .limit(options[:limit])
  end
end
