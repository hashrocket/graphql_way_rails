class User < ApplicationRecord
  has_many :orders

  def self.graphql_query(joins: nil, sort: nil, limit: nil)
    query = all
    query = query.joins(joins) if joins
    query = query.order(sort) if sort
    query = query.limit(limit) if limit
    query
  end
end
