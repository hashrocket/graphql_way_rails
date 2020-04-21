FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    color { rand(10) == 0 ? nil : Faker::Commerce.color }
    size { rand(10) == 0 ? nil : Faker::Creature::Dog.size }
    price { Faker::Commerce.price }
  end
end
