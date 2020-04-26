class User < ApplicationRecord
  has_many :orders

  scope :by_email, ->(email) { where(users: {email: email}) if email }

  def self.graphql_query(options)
    User.all
      .by_email(options[:email])
      .order(options[:sort])
      .limit(options[:limit])
  end
end
