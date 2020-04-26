class User < ApplicationRecord
  has_many :orders

  scope :page, ->(limit, page) { offset(limit * (page - 1)) if limit && page && page > 1 }
  scope :by_email, ->(email) { where(users: {email: email}) if email }

  def self.graphql_query(options)
    User.all
      .by_email(options[:email])
      .order(options[:sort])
      .limit(options[:limit])
      .page(options[:limit], options[:page])
  end
end
