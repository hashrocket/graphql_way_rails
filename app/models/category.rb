class Category < ApplicationRecord
  has_many :products

  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }
  scope :by_name, ->(name) { where("categories.name ILIKE ?", "#{name}%") if name }

  def self.graphql_query(options)
    Category.all
      .by_name(options[:name])
      .order(options[:sort])
      .limit(options[:limit])
      .page(options[:limit], options[:page])
  end
end
