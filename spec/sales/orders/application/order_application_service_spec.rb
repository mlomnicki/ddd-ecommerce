require 'spec_helper'
require 'sales/setup'
require 'support/fake_event_store'

RSpec.describe Sales::Application::Order::OrderApplicationService do
  let(:event_store) { FakeEventStore.new }
  let(:repository)  { Sales::Adapter::Persistence::OrderRepository.new(event_store) }

  subject { described_class.new(repository) }

  describe "#create_order" do
    let(:command) do
      Sales::Application::Order::CreateOrderCommand.new(
        order_id:    1,
        customer_id: 15
      )
    end

    it "should create a new order" do
      subject.create_order(command)

      expect(event_store).to publish_events([
        Sales::Domain::Order::OrderCreated.new(order_id: command.order_id, customer_id: command.customer_id)
      ])
    end
  end

  describe "#add_item_to_order" do
    let(:command) do
      Sales::Application::Order::AddItemToOrderCommand.new(
        order_id:   1,
        product_id: 2
      )
    end

    it "should add an item to order" do
      subject.add_item_to_order(command)

      expect(event_store).to publish_events([
        Sales::Domain::Order::ItemAddedToOrder.new(order_id: command.order_id, product_id: command.product_id)
      ])
    end
  end
end
