class Category < ApplicationRecord
  has_many :products

  scope :paginate, ->(sort, limit, page) { order(sort).limit(limit).page(limit, page) }
  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }
  scope :by_name, ->(name) { where("name ILIKE ?", "#{name}%") if name }

  def self.graphql_query(options)
    Category.all
      .by_name(options[:name])
      .paginate(options[:sort], options[:limit], options[:page])
  end
end
