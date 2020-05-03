class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  scope :paginate, ->(sort, limit, page) { order(sort).limit(limit).page(limit, page) }
  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }
  scope :by_min_ordered_at, ->(ordered_at) { where("ordered_at >= ?", ordered_at) if ordered_at }
  scope :by_max_ordered_at, ->(ordered_at) { where("ordered_at <= ?", ordered_at) if ordered_at }

  def self.graphql_query(options)
    Order.all
      .by_min_ordered_at(options[:min_ordered_at])
      .by_max_ordered_at(options[:max_ordered_at])
      .paginate(options[:sort].to_h, options[:limit], options[:page])
  end
end
