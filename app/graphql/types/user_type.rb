class Types::UserType < Types::BaseObject
  field :email, String, null: false
  field :orders, [Types::OrderType], null: false

  def orders
    Loaders::HasManyLoader.for(Order, :user_id).load(object.id)
  end
end
