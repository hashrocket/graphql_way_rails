class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  products_field

  def products(name: nil, color: nil, size: nil, min_price: nil, max_price: nil, sort: nil, limit: nil)
    query_options = {
      name: name,
      color: color,
      size: size,
      min_price: min_price,
      max_price: max_price,
      sort: sort,
      limit: limit
    }

    Loaders::HasManyLoader
      .for(Product, :category_id, query_options)
      .load(object.id)
  end
end
