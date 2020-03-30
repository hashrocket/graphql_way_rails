module Types
  class QueryType < Types::BaseObject
    field :categories, [Types::CategoryType], null: false
    field :products, [Types::ProductType], null: false
    field :users, [Types::UserType], null: false
    field :orders, [Types::OrderType], null: false

    def categories
      Category.all
    end

    def products
      Product.all
    end

    def users
      User.all
    end

    def orders
      Order.all
    end
  end
end
