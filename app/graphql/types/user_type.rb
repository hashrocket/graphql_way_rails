class Types::UserType < Types::BaseObject
  field :email, String, null: false
  field :orders, [Types::OrderType], null: false
end
