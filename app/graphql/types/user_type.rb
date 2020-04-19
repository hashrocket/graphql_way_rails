class Types::UserType < Types::BaseObject
  field :email, String, null: false
  orders_field

  def orders(sort: nil, limit: nil)
    Loaders::HasManyLoader
      .for(Order, :user_id, sort: sort, limit: limit)
      .load(object.id)
  end
end
