module Types
  class OrderType < Types::BaseObject
    field :ordered_on, String, null: false
    field :ordered_at, String, null: false
    field :user, Types::UserType, null: false
    field :products, [Types::ProductType], null: false

    def ordered_on
      object.ordered_at.strftime("%Y-%m-%d")
    end

    def ordered_at
      object.ordered_at.strftime("%H:%M")
    end
  end
end
