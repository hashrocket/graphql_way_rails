class Category < ApplicationRecord
  has_many :products

  scope :by_name, ->(name) { where("categories.name ILIKE ?", "#{name}%") if name }

  def self.graphql_query(name: nil, joins: nil, sort: nil, limit: nil)
    Category.all
      .by_name(name)
      .joins(joins)
      .order(sort)
      .limit(limit)
  end
end
