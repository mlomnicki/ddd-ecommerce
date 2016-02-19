require 'spec_helper'
require 'support/sales_helper'

RSpec.describe Sales::Application::Order::OrderApplicationService do
  include SalesHelper

  let(:event_store)        { FakeEventStore.new }
  let(:order_repository)   { Sales::Adapter::Persistence::OrderRepository.new(event_store) }
  let(:product_repository) { Sales::Adapter::Persistence::ProductRepository.new([product]) }

  let(:place_order_command) do
    Sales::Application::Order::PlaceOrderCommand.new(order_id: order_id, customer_id: customer_id)
  end

  let(:add_item_command) do
    Sales::Application::Order::AddItemToOrderCommand.new(order_id: order_id, product_id: product.id)
  end

  let(:expired_order_command) do
    Sales::Application::Order::ExpireOrderCommand.new(order_id: order_id)
  end

  let(:service) { described_class.new(order_repository, product_repository) }

  describe "#place_order" do
    it "creates a new order" do
      service.add_item_to_order(add_item_command)
      service.place_order(place_order_command)

      expect(event_store).to receive_events([
        Sales::Domain::ItemAddedToOrder.new(order_id: order_id, product_id: product.id, price: product.price),
        Sales::Domain::OrderPlaced.new(order_id: order_id, customer_id: customer_id, total_price: product.price)
      ])
    end
  end

  describe "#add_item_to_order" do
    it "adds an item to order" do
      service.add_item_to_order(add_item_command)

      expect(event_store).to receive_events([
        Sales::Domain::ItemAddedToOrder.new(order_id: order_id, product_id: product.id, price: product.price)
      ])
    end

    it "raises an error if product cannot be found" do
      expect do
        service.add_item_to_order(
          Sales::Application::Order::AddItemToOrderCommand.new(order_id: order_id, product_id: 321)
        )
      end.to raise_error(described_class::UnknownProduct)
    end
  end

  describe "#expire_order" do
    it "expires an order" do
      service.expire_order(expired_order_command)

      expect(event_store).to receive_events([
        Sales::Domain::OrderExpired.new(order_id: order_id)
      ])
    end
  end
end
