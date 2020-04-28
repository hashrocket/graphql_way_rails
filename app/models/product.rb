class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items

  scope :paginate, ->(sort, limit, page) { order(sort).limit(limit).page(limit, page) }
  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }
  scope :by_name, ->(name) { where("name ILIKE ?", "#{name}%") if name }
  scope :by_color, ->(color) { where(color: color) if color }
  scope :by_size, ->(size) { where(size: size) if size }
  scope :by_min_price, ->(price) { where("price >= ?", price) if price }
  scope :by_max_price, ->(price) { where("price <= ?", price) if price }

  def self.graphql_query(options)
    Product.all
      .by_name(options[:name])
      .by_color(options[:color])
      .by_size(options[:size])
      .by_min_price(options[:min_price])
      .by_max_price(options[:max_price])
      .paginate(options[:sort], options[:limit], options[:page])
  end
end
