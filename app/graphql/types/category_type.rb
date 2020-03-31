class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  field :products, [Types::ProductType], null: false

  def products
    Loaders::HasManyLoader.for(Product, :category_id).load(object.id)
  end
end
