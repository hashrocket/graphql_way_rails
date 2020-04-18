include FactoryBot::Syntax::Methods

puts "=> Creating Categories"
categories = (1..25).map do
  build(:category)
end
Category.import(categories)
category_ids = Category.ids

puts "=> Creating Products"
products = category_ids.flat_map do |category_id|
  (0..rand(50)).map do
    build(:product, category_id: category_id)
  end
end
Product.import(products)
product_ids = Product.ids

puts "=> Creating Users"
users = (1..100).map do
  build(:user)
end
User.import(users)
user_ids = User.ids

puts "=> Creating Orders"
orders = user_ids.flat_map do |user_id|
  (0..rand(50)).map do
    build(:order, user_id: user_id)
  end
end
Order.import(orders)
order_ids = Order.ids

puts "=> Creating OrderItems"
order_items = order_ids.flat_map do |order_id|
  (0..rand(10))
    .map { product_ids.sample }
    .uniq
    .map do |product_id|
      OrderItem.new(order_id: order_id, product_id: product_id)
    end
end
OrderItem.import(order_items)

puts "=> Seeding has finished successfully!"
