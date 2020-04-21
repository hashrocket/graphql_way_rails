class User < ApplicationRecord
  has_many :orders

  scope :by_email, ->(email) { where(users: {email: email}) if email }

  def self.graphql_query(email: nil, joins: nil, sort: nil, limit: nil)
    User.all
      .by_email(email)
      .joins(joins)
      .order(sort)
      .limit(limit)
  end
end
