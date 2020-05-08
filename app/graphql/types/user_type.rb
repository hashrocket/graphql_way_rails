class Types::UserType < Types::BaseObject
  field :email, String, null: false
  field_orders

  def orders(**query_options)
    Loaders::HasManyLoader
      .for(Order, :user_id, query_options)
      .load(object.id)
  end
end
