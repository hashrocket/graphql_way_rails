class Types::UserType < Types::BaseObject
  field :email, String, null: false
  field :orders, [Types::OrderType], null: false do
    sort_argument :ordered_at
  end

  def orders(sort: nil)
    Loaders::HasManyLoader
      .for(Order, :user_id, sort: sort)
      .load(object.id)
  end
end
