class Types::OrderType < Types::BaseObject
  field :ordered_on, String, null: false
  field :ordered_at, String, null: false
  field :user, Types::UserType, null: false
  field :products, [Types::ProductType], null: false

  def user
    Loaders::BelongsToLoader.for(User).load(object.user_id)
  end

  def products
    order_items.then do |order_item_list|
      product_ids = order_item_list.map(&:product_id)
      Loaders::BelongsToLoader.for(Product).load_many(product_ids)
    end
  end

  def ordered_on
    object.ordered_at.strftime("%Y-%m-%d")
  end

  def ordered_at
    object.ordered_at.strftime("%H:%M")
  end

  private

  def order_items
    Loaders::HasManyLoader.for(OrderItem, :order_id).load(object.id)
  end
end
