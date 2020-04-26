class GraphQLWayRailsDbSeed
  include FactoryBot::Syntax::Methods

  def run
    puts "=> Creating Categories"
    categories = build_list(:category, 25)
    Category.import(categories)
    category_ids = Category.ids

    puts "=> Creating Products"
    products = category_ids.flat_map { |category_id|
      build_list(:product, rand(50), category_id: category_id)
    }
    Product.import(products)
    product_ids = Product.ids

    puts "=> Creating Users"
    users = build_list(:user, 100)
    User.import(users)
    user_ids = User.ids

    puts "=> Creating Orders"
    orders = user_ids.flat_map { |user_id|
      build_list(:order, rand(50), user_id: user_id)
    }
    Order.import(orders)
    order_ids = Order.ids

    puts "=> Creating OrderItems"
    order_items = order_ids.flat_map { |order_id|
      product_ids
        .shuffle
        .take(rand(1..10))
        .map do |product_id|
          OrderItem.new(order_id: order_id, product_id: product_id)
        end
    }
    OrderItem.import(order_items)

    puts "=> Seeding has finished successfully!"
  end
end

GraphQLWayRailsDbSeed.new.run
