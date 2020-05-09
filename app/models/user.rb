class User < ApplicationRecord
  has_many :orders

  scope :by_email, ->(email) { where(email: email) if email }
  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }

  def self.graphql_query(options)
    User.all
      .by_email(options[:email])
      .order(options[:sort].to_h)
      .limit(options[:limit])
      .page(options[:limit], options[:page])
  end
end
