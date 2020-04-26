class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  products_field

  def products(**query_options)
    Loaders::HasManyLoader
      .for(Product, :category_id, query_options)
      .load(object.id)
  end
end
