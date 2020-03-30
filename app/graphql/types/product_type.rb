module Types
  class ProductType < Types::BaseObject
    field :name, String, null: false
    field :color, String, null: true
    field :size, String, null: true
    field :price_cents, Integer, null: false

    def price_cents
      (100 * object.price).to_i
    end
  end
end
