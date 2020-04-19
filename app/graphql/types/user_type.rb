class Types::UserType < Types::BaseObject
  field :email, String, null: false
  field :orders, [Types::OrderType], null: false do
    sort_argument :ordered_at
    limit_argument
  end

  def orders(sort: nil, limit: nil)
    Loaders::HasManyLoader
      .for(Order, :user_id, sort: sort, limit: limit)
      .load(object.id)
  end
end
