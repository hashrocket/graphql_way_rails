class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  products_field

  def products(sort: nil, limit: nil)
    Loaders::HasManyLoader
      .for(Product, :category_id, sort: sort, limit: limit)
      .load(object.id)
  end
end
