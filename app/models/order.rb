class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  scope :by_min_ordered_at, ->(ordered_at) { where("orders.ordered_at >= ?", ordered_at) if ordered_at }
  scope :by_max_ordered_at, ->(ordered_at) { where("orders.ordered_at <= ?", ordered_at) if ordered_at }

  def self.graphql_query(min_ordered_at: nil, max_ordered_at: nil, joins: nil, sort: nil, limit: nil)
    Order.all
      .by_min_ordered_at(min_ordered_at)
      .by_max_ordered_at(max_ordered_at)
      .joins(joins)
      .order(sort)
      .limit(limit)
  end
end
