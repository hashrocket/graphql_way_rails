class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  scope :by_min_ordered_at, ->(ordered_at) { where("orders.ordered_at >= ?", ordered_at) if ordered_at }
  scope :by_max_ordered_at, ->(ordered_at) { where("orders.ordered_at <= ?", ordered_at) if ordered_at }

  def self.graphql_query(minOrderedAt: nil, maxOrderedAt: nil, joins: nil, sort: nil, limit: nil)
    Order.all
      .by_min_ordered_at(minOrderedAt)
      .by_max_ordered_at(maxOrderedAt)
      .joins(joins)
      .order(sort)
      .limit(limit)
  end
end
