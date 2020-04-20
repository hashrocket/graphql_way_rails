class Types::UserType < Types::BaseObject
  field :email, String, null: false
  orders_field

  def orders(sort: nil, limit: nil)
    query_options = {
      sort: sort,
      limit: limit,
    }

    Loaders::HasManyLoader
      .for(Order, :user_id, query_options)
      .load(object.id)
  end
end
