module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField

    def self.categories_field
      field :categories, [Types::CategoryType], null: false do
        argument :name, String, required: false
        sort_argument name: "categories.name"
        limit_argument
        page_argument
      end
    end

    def self.products_field
      field :products, [Types::ProductType], null: false do
        argument :name, String, required: false
        argument :color, String, required: false
        argument :size, String, required: false
        argument :min_price_cents, Integer, required: false, prepare: ->(value, _ctx) { value && value / 100 }
        argument :max_price_cents, Integer, required: false, prepare: ->(value, _ctx) { value && value / 100 }
        sort_argument name: "products.name", color: "products.color", size: "products.size", price: "products.price"
        limit_argument
        page_argument
      end
    end

    def self.users_field
      field :users, [Types::UserType], null: false do
        argument :email, String, required: false
        sort_argument email: "users.email"
        limit_argument
        page_argument
      end
    end

    def self.orders_field
      field :orders, [Types::OrderType], null: false do
        argument :min_ordered_at, GraphQL::Types::ISO8601DateTime, required: false
        argument :max_ordered_at, GraphQL::Types::ISO8601DateTime, required: false
        sort_argument orderedAt: "orders.ordered_at"
        limit_argument
        page_argument
      end
    end
  end
end
