module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField

    def self.categories_field
      field :categories, [Types::CategoryType], null: false do
        argument :name, String, required: false
        argument(:sort, [Types::Enum::CategorySort], required: false, default_value: [])
        limit_argument
        page_argument
      end
    end

    def self.products_field
      field :products, [Types::ProductType], null: false do
        argument :name, String, required: false
        argument :color, String, required: false
        argument :size, String, required: false
        argument :min_price_cents, Integer, required: false, prepare: ->(value, _ctx) { value && value / 100 }, as: :min_price
        argument :max_price_cents, Integer, required: false, prepare: ->(value, _ctx) { value && value / 100 }, as: :max_price
        argument(:sort, [Types::Enum::ProductSort], required: false, default_value: [])
        limit_argument
        page_argument
      end
    end

    def self.users_field
      field :users, [Types::UserType], null: false do
        argument :email, String, required: false
        argument(:sort, [Types::Enum::UserSort], required: false, default_value: [])
        limit_argument
        page_argument
      end
    end

    def self.orders_field
      field :orders, [Types::OrderType], null: false do
        argument :min_ordered_at, GraphQL::Types::ISO8601DateTime, required: false
        argument :max_ordered_at, GraphQL::Types::ISO8601DateTime, required: false
        argument(:sort, [Types::Enum::OrderSort], required: false, default_value: [])
        limit_argument
        page_argument
      end
    end
  end
end
