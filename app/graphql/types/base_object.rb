module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField

    def self.categories_field
      field :categories, [Types::CategoryType], null: false do
        sort_argument :name
        limit_argument
      end
    end

    def self.products_field
      field :products, [Types::ProductType], null: false do
        sort_argument :name, :color, :size, :price
        limit_argument
      end
    end

    def self.users_field
      field :users, [Types::UserType], null: false do
        sort_argument :email
        limit_argument
      end
    end

    def self.orders_field
      field :orders, [Types::OrderType], null: false do
        sort_argument :ordered_at
        limit_argument
      end
    end
  end
end
