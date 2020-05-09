class Category < ApplicationRecord
  has_many :products

  scope :by_name, ->(name) { where("name ILIKE ?", "#{name}%") if name }
  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }

  def self.graphql_query(options)
    Category.all
      .by_name(options[:name])
      .order(options[:sort].to_h)
      .limit(options[:limit])
      .page(options[:limit], options[:page])
  end
end
