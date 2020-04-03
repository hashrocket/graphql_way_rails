class Types::OrderType < Types::BaseObject
  field :ordered_on, String, null: false
  field :ordered_at, String, null: false
  field :user, Types::UserType, null: false
  field :products, [Types::ProductType], null: false

  def user
    Loaders::BelongsToLoader.for(User).load(object.user_id)
  end

  def products
    Loaders::HasManyThroughLoader
      .for(Product, :order_id, through: :order_items)
      .load(object.id)
  end

  def ordered_on
    object.ordered_at.strftime("%Y-%m-%d")
  end

  def ordered_at
    object.ordered_at.strftime("%H:%M")
  end
end
