require 'spec_helper'
require 'sales/setup'
require 'support/fake_event_store'

RSpec.describe Sales::Application::Order::OrderApplicationService do
  let(:event_store) { FakeEventStore.new }
  let(:repository)  { Sales::Adapter::Persistence::OrderRepository.new(event_store) }

  let(:create_order_command) do
    Sales::Application::Order::CreateOrderCommand.new(
      order_id:    1,
      customer_id: 15
    )
  end

  let(:add_item_command) do
    Sales::Application::Order::AddItemToOrderCommand.new(
      order_id:   1,
      product_id: 2
    )
  end

  let(:expired_order_command) do
    Sales::Application::Order::ExpireOrderCommand.new(
      order_id: 1
    )
  end

  let(:service) { described_class.new(repository) }

  describe "#create_order" do
    let(:command) { create_order_command }

    it "creates a new order" do
      service.add_item_to_order(add_item_command)
      service.create_order(command)

      expect(event_store).to receive_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: command.order_id, product_id: add_item_command.product_id),
        Sales::Domain::Order::OrderCreated.new(order_id: command.order_id, customer_id: command.customer_id)
      ])
    end
  end

  describe "#add_item_to_order" do
    let(:command) { add_item_command }

    it "adds an item to order" do
      service.add_item_to_order(command)

      expect(event_store).to receive_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: command.order_id, product_id: command.product_id)
      ])
    end
  end

  describe "#expire_order" do
    let(:command) { expired_order_command }

    it "expires an order" do
      service.expire_order(command)

      expect(event_store).to receive_events([
        Sales::Domain::Order::OrderExpired.new(order_id: command.order_id)
      ])
    end
  end
end
