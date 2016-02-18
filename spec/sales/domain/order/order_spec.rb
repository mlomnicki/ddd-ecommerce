require 'spec_helper'

RSpec.describe Sales::Domain::Order::Order do
  let(:aggregate_id) { 1 }
  let(:customer_id)  { 12 }
  let(:product_id)   { 5 }
  let(:price)        { Common::Domain::Money.from_float(12.50) }

  let(:order) { described_class.new(aggregate_id) }

  describe "#place" do
    it "places an order" do
      order.add_item(product_id, price)
      order.place(customer_id)

      expect(order).to raise_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id, price: price.to_i),
        Sales::Domain::Order::OrderPlaced.new(order_id: aggregate_id, customer_id: customer_id)
      ])
    end

    it "does not allow to place an empty order" do
      expect { order.place(customer_id) }.to raise_error(described_class::MissingItems)
    end

    it "does not allow to place an already placed order" do
      order.add_item(product_id, price)
      order.place(customer_id)

      expect { order.place(customer_id) }.to raise_error(described_class::AlreadyPlaced)
    end
  end

  describe "#add_item" do
    it "adds an item to the order" do
      order.add_item(product_id, price)

      expect(order).to raise_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id, price: price.to_i)
      ])
    end

    it "does not allow to add items to placed order" do
      order.add_item(product_id, price)
      order.place(customer_id)

      expect { order.add_item(product_id, price) }.to raise_error(described_class::AlreadyPlaced)
    end
  end

  describe "#expire" do
    it "expires an order" do
      order.expire

      expect(order).to raise_events([
        Sales::Domain::Order::OrderExpired.new(order_id: aggregate_id)
      ])
    end

    it "does not allow to expire a placed order" do
      order.add_item(product_id, price)
      order.place(customer_id)

      expect { order.expire }.to raise_error(described_class::AlreadyPlaced)
    end
  end
end
