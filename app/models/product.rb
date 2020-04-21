class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items

  scope :by_name, ->(name) { where("products.name ILIKE ?", "#{name}%") if name }
  scope :by_color, ->(color) { where(products: {color: color}) if color }
  scope :by_size, ->(size) { where(products: {size: size}) if size }
  scope :by_min_price, ->(price) { where("products.price >= ?", price) if price }
  scope :by_max_price, ->(price) { where("products.price <= ?", price) if price }

  def self.graphql_query(name: nil, color: nil, size: nil, minPrice: nil, maxPrice: nil, joins: nil, sort: nil, limit: nil)
    Product.all
      .by_name(name)
      .by_color(color)
      .by_size(size)
      .by_min_price(minPrice && minPrice / 100)
      .by_max_price(maxPrice && maxPrice / 100)
      .joins(joins)
      .order(sort)
      .limit(limit)
  end
end
