class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  products_field

  def products(name: nil, color: nil, size: nil, minPrice: nil, maxPrice: nil, sort: nil, limit: nil)
    query_options = {
      name: name,
      color: color,
      size: size,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
      limit: limit,
    }

    Loaders::HasManyLoader
      .for(Product, :category_id, query_options)
      .load(object.id)
  end
end
