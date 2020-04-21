class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  def self.graphql_query(minOrderedAt: nil, maxOrderedAt: nil, joins: nil, sort: nil, limit: nil)
    query = all
    query = query.where("orders.ordered_at >= ?", minOrderedAt) if minOrderedAt
    query = query.where("orders.ordered_at <= ?", maxOrderedAt) if maxOrderedAt
    query = query.joins(joins) if joins
    query = query.order(sort) if sort
    query = query.limit(limit) if limit
    query
  end
end
