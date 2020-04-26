class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }

  def self.graphql_query(options)
    if options[:order]
      order_options = options[:order].except(:sort, :limit, :page)

      return graphql_query(options[:order].slice(:sort, :limit, :page))
          .joins(:order)
          .merge(Order.graphql_query(order_options))
    end

    if options[:product]
      product_options = options[:product].except(:sort, :limit, :page)

      return graphql_query(options[:product].slice(:sort, :limit, :page))
          .joins(:product)
          .merge(Product.graphql_query(product_options))
    end

    OrderItem.all
      .order(options[:sort])
      .limit(options[:limit])
      .page(options[:limit], options[:page])
  end
end
