class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  products_field

  def products(sort: nil, limit: nil)
    query_options = {
      sort: sort,
      limit: limit,
    }

    Loaders::HasManyLoader
      .for(Product, :category_id, query_options)
      .load(object.id)
  end
end
