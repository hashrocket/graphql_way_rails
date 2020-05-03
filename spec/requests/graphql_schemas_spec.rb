require "rails_helper"

RSpec.describe "GraphqlSchemas", type: :request do
  def query(gql, **variables)
    GraphqlWayRailsSchema.execute(gql, variables: variables).to_h
  end

  describe "categories" do
    let!(:books) { create(:category, name: "Books") }
    let!(:games) { create(:category, name: "Games") }
    let!(:tools) { create(:category, name: "Tools") }
    let!(:hammer) { create(:product, category: tools, name: "Hammer", color: "black", size: "small", price: 10.0) }

    it "gets categories with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($name: String, $sort: [CategorySort!], $limit: Int, $page: Int) {
          categories(name: $name, sort: $sort, limit: $limit, page: $page) {
            name
          }
        }
      GRAPHQL

      expect(query(gql)["data"]["categories"]).to match_array([
        {"name" => books.name},
        {"name" => games.name},
        {"name" => tools.name}
      ])

      expect(query(gql, name: "gam")).to eq({"data" => {
        "categories" => [
          {"name" => games.name}
        ]
      }})

      expect(query(gql, sort: ["nameAsc"])).to eq({"data" => {
        "categories" => [
          {"name" => books.name},
          {"name" => games.name},
          {"name" => tools.name}
        ]
      }})

      expect(query(gql, sort: ["nameDesc"])).to eq({"data" => {
        "categories" => [
          {"name" => tools.name},
          {"name" => games.name},
          {"name" => books.name}
        ]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2)).to eq({"data" => {
        "categories" => [
          {"name" => books.name},
          {"name" => games.name}
        ]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2, page: 2)).to eq({"data" => {
        "categories" => [
          {"name" => tools.name}
        ]
      }})
    end

    it "gets products.category" do
      gql = <<-GRAPHQL
        query {
          products {
            name
            category {
              name
            }
          }
        }
      GRAPHQL

      expect(query(gql)).to eq({"data" => {
        "products" => [
          {
            "name" => hammer.name,
            "category" => {
              "name" => tools.name
            }
          }
        ]
      }})
    end
  end

  describe "products" do
    let!(:tools) { create(:category, name: "Tools") }
    let!(:clamps) { create(:product, category: tools, name: "Clamps", color: "silver", size: "large", price: 15.0) }
    let!(:hammer) { create(:product, category: tools, name: "Hammer", color: "black", size: "small", price: 10.0) }
    let!(:pliers) { create(:product, category: tools, name: "Pliers", color: "green", size: "medium", price: 5.0) }
    let!(:alan) { create(:user, email: "alan@mail.com") }
    let!(:order_1st) { create(:order, user: alan, ordered_at: DateTime.parse("2020-04-01T08:00:00Z")) }

    before do
      [clamps, hammer, pliers].each do |product|
        OrderItem.create(order: order_1st, product: product)
      end
    end

    it "gets products with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($name: String, $color: String, $size: String, $min_price_cents: Int, $max_price_cents: Int, $sort: [ProductSort!], $limit: Int, $page: Int) {
          products(name: $name, color: $color, size: $size, minPriceCents: $min_price_cents, maxPriceCents: $max_price_cents, sort: $sort, limit: $limit, page: $page) {
            name
            color
            size
            priceCents
          }
        }
      GRAPHQL

      expect(query(gql)["data"]["products"]).to match_array([
        {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
        {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
        {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
      ])

      expect(query(gql, name: "ham")).to eq({"data" => {
        "products" => [
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
        ]
      }})

      expect(query(gql, color: "black")).to eq({"data" => {
        "products" => [
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
        ]
      }})

      expect(query(gql, size: "small")).to eq({"data" => {
        "products" => [
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
        ]
      }})

      expect(query(gql, min_price_cents: 800, max_price_cents: 1200)).to eq({"data" => {
        "products" => [
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
        ]
      }})

      expect(query(gql, sort: ["nameAsc"])).to eq({"data" => {
        "products" => [
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
        ]
      }})

      expect(query(gql, sort: ["nameDesc"])).to eq({"data" => {
        "products" => [
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
        ]
      }})

      expect(query(gql, sort: ["colorAsc"])).to eq({"data" => {
        "products" => [
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
        ]
      }})

      expect(query(gql, sort: ["colorDesc"])).to eq({"data" => {
        "products" => [
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
        ]
      }})

      expect(query(gql, sort: ["sizeAsc"])).to eq({"data" => {
        "products" => [
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
        ]
      }})

      expect(query(gql, sort: ["sizeDesc"])).to eq({"data" => {
        "products" => [
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
        ]
      }})

      expect(query(gql, sort: ["priceAsc"])).to eq({"data" => {
        "products" => [
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
        ]
      }})

      expect(query(gql, sort: ["priceDesc"])).to eq({"data" => {
        "products" => [
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
        ]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2)).to eq({"data" => {
        "products" => [
          {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
          {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
        ]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2, page: 2)).to eq({"data" => {
        "products" => [
          {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
        ]
      }})
    end

    it "gets categories.products with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($name: String, $color: String, $size: String, $min_price_cents: Int, $max_price_cents: Int, $sort: [ProductSort!], $limit: Int, $page: Int) {
          categories {
            name
            products(name: $name, color: $color, size: $size, minPriceCents: $min_price_cents, maxPriceCents: $max_price_cents, sort: $sort, limit: $limit, page: $page) {
              name
              color
              size
              priceCents
            }
          }
        }
      GRAPHQL

      expect(query(gql)).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})

      expect(query(gql, name: "ham")).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, color: "black")).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, size: "small")).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, min_price_cents: 800, max_price_cents: 1200)).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameAsc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameDesc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["colorAsc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["colorDesc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["sizeAsc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["sizeDesc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["priceAsc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["priceDesc"])).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2)).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2, page: 2)).to eq({"data" => {
        "categories" => [{
          "name" => tools.name,
          "products" => [
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})
    end

    it "gets orders.products with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($name: String, $color: String, $size: String, $min_price_cents: Int, $max_price_cents: Int, $sort: [ProductSort!], $limit: Int, $page: Int) {
          orders {
            orderedAt
            products(name: $name, color: $color, size: $size, minPriceCents: $min_price_cents, maxPriceCents: $max_price_cents, sort: $sort, limit: $limit, page: $page) {
              name
              color
              size
              priceCents
            }
          }
        }
      GRAPHQL

      expect(query(gql)).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})

      expect(query(gql, name: "ham")).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, color: "black")).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, size: "small")).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, min_price_cents: 800, max_price_cents: 1200)).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameAsc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameDesc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["colorAsc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["colorDesc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["sizeAsc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["sizeDesc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["priceAsc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500}
          ]
        }]
      }})

      expect(query(gql, sort: ["priceDesc"])).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000},
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2)).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => clamps.name, "color" => clamps.color, "size" => clamps.size, "priceCents" => 1500},
            {"name" => hammer.name, "color" => hammer.color, "size" => hammer.size, "priceCents" => 1000}
          ]
        }]
      }})

      expect(query(gql, sort: ["nameAsc"], limit: 2, page: 2)).to eq({"data" => {
        "orders" => [{
          "orderedAt" => order_1st.ordered_at.iso8601,
          "products" => [
            {"name" => pliers.name, "color" => pliers.color, "size" => pliers.size, "priceCents" => 500}
          ]
        }]
      }})
    end
  end

  describe "orders" do
    let!(:alan) { create(:user, email: "alan@mail.com") }
    let!(:order_1st) { create(:order, user: alan, ordered_at: DateTime.parse("2020-04-01T08:00:00Z")) }
    let!(:order_2nd) { create(:order, user: alan, ordered_at: DateTime.parse("2020-04-02T08:00:00Z")) }
    let!(:order_3rd) { create(:order, user: alan, ordered_at: DateTime.parse("2020-04-03T08:00:00Z")) }
    let!(:tools) { create(:category, name: "Tools") }
    let!(:hammer) { create(:product, category: tools, name: "Hammer", color: "black", size: "small", price: 10.0) }

    before do
      [order_1st, order_2nd, order_3rd].each do |order|
        OrderItem.create(order: order, product: hammer)
      end
    end

    it "gets orders with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($min_ordered_at: ISO8601DateTime, $max_ordered_at: ISO8601DateTime, $sort: [OrderSort!], $limit: Int, $page: Int) {
          orders(minOrderedAt: $min_ordered_at, maxOrderedAt: $max_ordered_at, sort: $sort, limit: $limit, page: $page) {
            orderedAt
          }
        }
      GRAPHQL

      expect(query(gql)["data"]["orders"]).to match_array([
        {"orderedAt" => order_1st.ordered_at.iso8601},
        {"orderedAt" => order_2nd.ordered_at.iso8601},
        {"orderedAt" => order_3rd.ordered_at.iso8601}
      ])

      expect(query(gql, min_ordered_at: "2020-04-02", max_ordered_at: "2020-04-03")).to eq({"data" => {
        "orders" => [
          {"orderedAt" => order_2nd.ordered_at.iso8601}
        ]
      }})

      expect(query(gql, sort: ["orderedAtAsc"])).to eq({"data" => {
        "orders" => [
          {"orderedAt" => order_1st.ordered_at.iso8601},
          {"orderedAt" => order_2nd.ordered_at.iso8601},
          {"orderedAt" => order_3rd.ordered_at.iso8601}
        ]
      }})

      expect(query(gql, sort: ["orderedAtDesc"])).to eq({"data" => {
        "orders" => [
          {"orderedAt" => order_3rd.ordered_at.iso8601},
          {"orderedAt" => order_2nd.ordered_at.iso8601},
          {"orderedAt" => order_1st.ordered_at.iso8601}
        ]
      }})

      expect(query(gql, sort: ["orderedAtAsc"], limit: 2)).to eq({"data" => {
        "orders" => [
          {"orderedAt" => order_1st.ordered_at.iso8601},
          {"orderedAt" => order_2nd.ordered_at.iso8601}
        ]
      }})

      expect(query(gql, sort: ["orderedAtAsc"], limit: 2, page: 2)).to eq({"data" => {
        "orders" => [
          {"orderedAt" => order_3rd.ordered_at.iso8601}
        ]
      }})
    end

    it "gets users.orders with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($min_ordered_at: ISO8601DateTime, $max_ordered_at: ISO8601DateTime, $sort: [OrderSort!], $limit: Int, $page: Int) {
          users {
            email
            orders(minOrderedAt: $min_ordered_at, maxOrderedAt: $max_ordered_at, sort: $sort, limit: $limit, page: $page) {
              orderedAt
            }
          }
        }
      GRAPHQL

      expect(query(gql)).to eq({"data" => {
        "users" => [{
          "email" => alan.email,
          "orders" => [
            {"orderedAt" => order_1st.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601},
            {"orderedAt" => order_3rd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, min_ordered_at: "2020-04-02", max_ordered_at: "2020-04-03")).to eq({"data" => {
        "users" => [{
          "email" => alan.email,
          "orders" => [
            {"orderedAt" => order_2nd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtAsc"])).to eq({"data" => {
        "users" => [{
          "email" => alan.email,
          "orders" => [
            {"orderedAt" => order_1st.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601},
            {"orderedAt" => order_3rd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtDesc"])).to eq({"data" => {
        "users" => [{
          "email" => alan.email,
          "orders" => [
            {"orderedAt" => order_3rd.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601},
            {"orderedAt" => order_1st.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtAsc"], limit: 2)).to eq({"data" => {
        "users" => [{
          "email" => alan.email,
          "orders" => [
            {"orderedAt" => order_1st.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtAsc"], limit: 2, page: 2)).to eq({"data" => {
        "users" => [{
          "email" => alan.email,
          "orders" => [
            {"orderedAt" => order_3rd.ordered_at.iso8601}
          ]
        }]
      }})
    end

    it "gets products.orders with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($min_ordered_at: ISO8601DateTime, $max_ordered_at: ISO8601DateTime, $sort: [OrderSort!], $limit: Int, $page: Int) {
          products {
            name
            orders(minOrderedAt: $min_ordered_at, maxOrderedAt: $max_ordered_at, sort: $sort, limit: $limit, page: $page) {
              orderedAt
            }
          }
        }
      GRAPHQL

      expect(query(gql)).to eq({"data" => {
        "products" => [{
          "name" => hammer.name,
          "orders" => [
            {"orderedAt" => order_1st.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601},
            {"orderedAt" => order_3rd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, min_ordered_at: "2020-04-02", max_ordered_at: "2020-04-03")).to eq({"data" => {
        "products" => [{
          "name" => hammer.name,
          "orders" => [
            {"orderedAt" => order_2nd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtAsc"])).to eq({"data" => {
        "products" => [{
          "name" => hammer.name,
          "orders" => [
            {"orderedAt" => order_1st.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601},
            {"orderedAt" => order_3rd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtDesc"])).to eq({"data" => {
        "products" => [{
          "name" => hammer.name,
          "orders" => [
            {"orderedAt" => order_3rd.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601},
            {"orderedAt" => order_1st.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtAsc"], limit: 2)).to eq({"data" => {
        "products" => [{
          "name" => hammer.name,
          "orders" => [
            {"orderedAt" => order_1st.ordered_at.iso8601},
            {"orderedAt" => order_2nd.ordered_at.iso8601}
          ]
        }]
      }})

      expect(query(gql, sort: ["orderedAtAsc"], limit: 2, page: 2)).to eq({"data" => {
        "products" => [{
          "name" => hammer.name,
          "orders" => [
            {"orderedAt" => order_3rd.ordered_at.iso8601}
          ]
        }]
      }})
    end
  end

  describe "users" do
    let!(:alan) { create(:user, email: "alan@mail.com") }
    let!(:john) { create(:user, email: "john@mail.com") }
    let!(:zeek) { create(:user, email: "zeek@mail.com") }
    let!(:order_1st) { create(:order, user: alan, ordered_at: DateTime.parse("2020-04-01T08:00:00Z")) }

    it "gets users with filters, sort and limit" do
      gql = <<-GRAPHQL
        query($email: String, $sort: [UserSort!], $limit: Int, $page: Int) {
          users(email: $email, sort: $sort, limit: $limit, page: $page) {
            email
          }
        }
      GRAPHQL

      expect(query(gql)["data"]["users"]).to match_array([
        {"email" => alan.email},
        {"email" => john.email},
        {"email" => zeek.email}
      ])

      expect(query(gql, email: "john@mail.com")).to eq({"data" => {
        "users" => [
          {"email" => john.email}
        ]
      }})

      expect(query(gql, sort: ["emailAsc"])).to eq({"data" => {
        "users" => [
          {"email" => alan.email},
          {"email" => john.email},
          {"email" => zeek.email}
        ]
      }})

      expect(query(gql, sort: ["emailDesc"])).to eq({"data" => {
        "users" => [
          {"email" => zeek.email},
          {"email" => john.email},
          {"email" => alan.email}
        ]
      }})

      expect(query(gql, sort: ["emailAsc"], limit: 2)).to eq({"data" => {
        "users" => [
          {"email" => alan.email},
          {"email" => john.email}
        ]
      }})

      expect(query(gql, sort: ["emailAsc"], limit: 2, page: 2)).to eq({"data" => {
        "users" => [
          {"email" => zeek.email}
        ]
      }})
    end

    it "gets orders.user" do
      gql = <<-GRAPHQL
        query {
          orders {
            orderedAt
            user {
              email
            }
          }
        }
      GRAPHQL

      expect(query(gql)).to eq({"data" => {
        "orders" => [
          {
            "orderedAt" => order_1st.ordered_at.iso8601,
            "user" => {
              "email" => alan.email
            }
          }
        ]
      }})
    end
  end
end
