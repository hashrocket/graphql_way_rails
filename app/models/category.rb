class Category < ApplicationRecord
  has_many :products

  scope :by_name, ->(name) { where("categories.name ILIKE ?", "#{name}%") if name }

  def self.graphql_query(options)
    Category.all
      .by_name(options[:name])
      .order(options[:sort])
      .limit(options[:limit])
  end
end
