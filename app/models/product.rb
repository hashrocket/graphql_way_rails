class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items

  scope :by_name, ->(name) { where("products.name ILIKE ?", "#{name}%") if name }
  scope :by_color, ->(color) { where(products: {color: color}) if color }
  scope :by_size, ->(size) { where(products: {size: size}) if size }
  scope :by_min_price, ->(price) { where("products.price >= ?", price) if price }
  scope :by_max_price, ->(price) { where("products.price <= ?", price) if price }

  def self.graphql_query(options)
    Product.all
      .by_name(options[:name])
      .by_color(options[:color])
      .by_size(options[:size])
      .by_min_price(options[:min_price] && options[:min_price] / 100)
      .by_max_price(options[:max_price] && options[:max_price] / 100)
      .order(options[:sort])
      .limit(options[:limit])
  end
end
