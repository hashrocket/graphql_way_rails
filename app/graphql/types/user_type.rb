class Types::UserType < Types::BaseObject
  field :email, String, null: false
  orders_field

  def orders(min_ordered_at: nil, max_ordered_at: nil, sort: nil, limit: nil)
    query_options = {
      min_ordered_at: min_ordered_at,
      max_ordered_at: max_ordered_at,
      sort: sort,
      limit: limit
    }

    Loaders::HasManyLoader
      .for(Order, :user_id, query_options)
      .load(object.id)
  end
end
