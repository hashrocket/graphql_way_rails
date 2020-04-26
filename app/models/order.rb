class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  scope :by_min_ordered_at, ->(ordered_at) { where("orders.ordered_at >= ?", ordered_at) if ordered_at }
  scope :by_max_ordered_at, ->(ordered_at) { where("orders.ordered_at <= ?", ordered_at) if ordered_at }

  def self.graphql_query(options)
    Order.all
      .by_min_ordered_at(options[:min_ordered_at])
      .by_max_ordered_at(options[:max_ordered_at])
      .order(options[:sort])
      .limit(options[:limit])
  end
end
