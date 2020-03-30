class Types::CategoryType < Types::BaseObject
  field :name, String, null: false
  field :products, [Types::ProductType], null: false
end
