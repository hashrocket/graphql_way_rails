class User < ApplicationRecord
  has_many :orders

  scope :paginate, ->(sort, limit, page) { order(sort).limit(limit).page(limit, page) }
  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }
  scope :by_email, ->(email) { where(email: email) if email }

  def self.graphql_query(options)
    User.all
      .by_email(options[:email])
      .paginate(options[:sort], options[:limit], options[:page])
  end
end
