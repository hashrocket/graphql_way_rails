class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  field :products, [Types::ProductType], null: false do
    sort_argument :name, :color, :size, :price
    limit_argument
  end

  def products(sort: nil, limit: nil)
    Loaders::HasManyLoader
      .for(Product, :category_id, sort: sort, limit: limit)
      .load(object.id)
  end
end
