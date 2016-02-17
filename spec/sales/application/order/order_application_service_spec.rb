require 'spec_helper'
require 'sales/setup'
require 'support/fake_event_store'

RSpec.describe Sales::Application::Order::OrderApplicationService do
  let(:event_store) { FakeEventStore.new }
  let(:repository)  { Sales::Adapter::Persistence::OrderRepository.new(event_store) }

  let(:order_id)    { 1 }
  let(:customer_id) { 15 }
  let(:product_id)  { 30 }
  let(:price)       { Common::Domain::Money.from_float(25.99) }

  let(:create_order_command) do
    Sales::Application::Order::CreateOrderCommand.new(order_id: order_id, customer_id: customer_id)
  end

  let(:add_item_command) do
    Sales::Application::Order::AddItemToOrderCommand.new(order_id: order_id, product_id: product_id)
  end

  let(:expired_order_command) do
    Sales::Application::Order::ExpireOrderCommand.new(order_id: order_id)
  end

  let(:service) { described_class.new(repository, price) }

  describe "#create_order" do
    it "creates a new order" do
      service.add_item_to_order(add_item_command)
      service.create_order(create_order_command)

      expect(event_store).to receive_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: order_id, product_id: product_id, price: price.to_i),
        Sales::Domain::Order::OrderCreated.new(order_id: order_id, customer_id: customer_id)
      ])
    end
  end

  describe "#add_item_to_order" do
    it "adds an item to order" do
      service.add_item_to_order(add_item_command)

      expect(event_store).to receive_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: order_id, product_id: product_id, price: price.to_i)
      ])
    end
  end

  describe "#expire_order" do
    it "expires an order" do
      service.expire_order(expired_order_command)

      expect(event_store).to receive_events([
        Sales::Domain::Order::OrderExpired.new(order_id: order_id)
      ])
    end
  end
end
