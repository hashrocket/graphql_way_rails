class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  field :products, [Types::ProductType], null: false do
    sort_argument :name, :color, :size, :price
  end

  def products(sort: nil)
    Loaders::HasManyLoader
      .for(Product, :category_id, sort: sort)
      .load(object.id)
  end
end
