class Category < ApplicationRecord
  has_many :products

  def self.graphql_query(name: nil, joins: nil, sort: nil, limit: nil)
    query = all
    query = query.where("categories.name ILIKE ?", "#{name}%") if name
    query = query.joins(joins) if joins
    query = query.order(sort) if sort
    query = query.limit(limit) if limit
    query
  end
end
