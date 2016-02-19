require 'spec_helper'

RSpec.describe Sales::Domain::Order do
  let(:aggregate_id) { 1 }
  let(:customer_id)  { 12 }
  let(:product_id)   { 5 }
  let(:unit_price)   { Money.from_float(12.50) }

  let(:order) { described_class.new(aggregate_id) }

  describe "#place" do
    it "places an order" do
      order.add_item(product_id, unit_price)
      order.place(customer_id)

      expect(order).to raise_events([
        Sales::Domain::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id, price: unit_price),
        Sales::Domain::OrderPlaced.new(order_id: aggregate_id, customer_id: customer_id, total_price: unit_price)
      ])
    end

    it "does not allow to place an empty order" do
      expect { order.place(customer_id) }.to raise_error(described_class::MissingItems)
    end

    it "does not allow to place an already placed order" do
      order.add_item(product_id, unit_price)
      order.place(customer_id)

      expect { order.place(customer_id) }.to raise_error(described_class::AlreadyPlaced)
    end
  end

  describe "#add_item" do
    it "adds an item to the order" do
      order.add_item(product_id, unit_price)

      expect(order).to raise_events([
        Sales::Domain::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id, price: unit_price)
      ])
    end

    it "does not allow to add items to placed order" do
      order.add_item(product_id, unit_price)
      order.place(customer_id)

      expect { order.add_item(product_id, unit_price) }.to raise_error(described_class::AlreadyPlaced)
    end
  end

  describe "#expire" do
    it "expires an order" do
      order.expire

      expect(order).to raise_events([
        Sales::Domain::OrderExpired.new(order_id: aggregate_id)
      ])
    end

    it "does not allow to expire a placed order" do
      order.add_item(product_id, unit_price)
      order.place(customer_id)

      expect { order.expire }.to raise_error(described_class::AlreadyPlaced)
    end
  end

  describe "#apply_discount" do
    let(:product_price) { Money.from_float(21) }
    let(:discount)      { Money.from_float(5.5) }

    let(:expected_price)  { Money.from_float(15.5) }

    it "applies discount to order" do
      order.add_item(product_id, product_price)
      order.apply_discount(discount)
      order.place(customer_id)

      expect(order).to raise_events([
        Sales::Domain::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id, price: product_price),
        Sales::Domain::DiscountApplied.new(order_id: aggregate_id, amount: discount),
        Sales::Domain::OrderPlaced.new(order_id: aggregate_id, customer_id: customer_id, total_price: expected_price)
      ])
    end

    it "allows to set discount first and then add items" do
      order.apply_discount(discount)
      order.add_item(product_id, product_price)
      order.place(customer_id)

      expect(order).to raise_events([
        Sales::Domain::DiscountApplied.new(order_id: aggregate_id, amount: discount),
        Sales::Domain::ItemAddedToOrder.new(order_id: aggregate_id, product_id: product_id, price: product_price),
        Sales::Domain::OrderPlaced.new(order_id: aggregate_id, customer_id: customer_id, total_price: expected_price)
      ])
    end

    it "does not allow to apply discount to placed order" do
      order.add_item(product_id, product_price)
      order.place(customer_id)

      expect { order.apply_discount(discount) }.to raise_error(described_class::AlreadyPlaced)
    end
  end
end
