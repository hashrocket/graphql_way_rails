class Types::UserType < Types::BaseObject
  field :email, String, null: false
  orders_field

  def orders(**query_options)
    Loaders::HasManyLoader
      .for(Order, :user_id, query_options)
      .load(object.id)
  end
end
