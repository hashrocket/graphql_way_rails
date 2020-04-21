FactoryBot.define do
  factory :order do
    ordered_at { Faker::Time.backward(days: 14) }
  end
end
