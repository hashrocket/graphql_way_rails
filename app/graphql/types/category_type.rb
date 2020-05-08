class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  field_products

  def products(**query_options)
    Loaders::HasManyLoader
      .for(Product, :category_id, query_options)
      .load(object.id)
  end
end
