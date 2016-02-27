require 'spec_helper'
require 'support/sales_helper'

RSpec.describe Sales::OrderSaga do
  include SalesHelper

  let(:command_bus)        { CommandBus.new }
  let(:event_store)        { FakeEventStore.new }
  let(:order_repository)   { Sales::Adapter::Persistence::OrderRepository.new(event_store) }
  let(:saga_repository)    { Sales::Adapter::Persistence::OrderSagaRepository.new(event_store) }
  let(:product_repository) { Sales::Adapter::Persistence::ProductRepository.new([product]) }
  let(:order_saga_manager) { Sales::OrderSagaManager.new(saga_repository, command_bus) }

  let(:gateway_response) { Sales::Adapter::Payment::Success.new(payment_id) }
  let(:payment_api)      { Sales::Adapter::Payment::Api.new(gateway_response) }
  let(:payment_gateway)  { Sales::Adapter::Payment::Gateway.new(event_store, payment_api) }

  let(:order_service) do
    Sales::Application::OrderApplicationService.new(order_repository, product_repository)
  end

  let(:payment_service) do
    Sales::Application::PaymentApplicationService.new(payment_gateway)
  end

  let(:events_setup) do
    {
      order_saga_manager => [
        Sales::Domain::OrderPlaced,
        Sales::Domain::PaymentSucceeded,
        Sales::Domain::PaymentFailed
      ]
    }
  end

  let(:commands_setup) do
    {
      Sales::Application::AddItemToOrder => order_service.method(:add_item_to_order),
      Sales::Application::PlaceOrder     => order_service.method(:place_order),
      Sales::Application::CompleteOrder  => order_service.method(:complete_order),
      Sales::Application::CancelOrder    => order_service.method(:cancel_order),
      Sales::Application::RequestPayment => payment_service.method(:request_payment)
    }
  end

  before do
    events_setup.each   { |handler, events|  event_store.subscribe(handler, events) }
    commands_setup.each { |command, handler| command_bus.register(command, handler) }
  end

  describe "with successful payment" do
    it "completes the order" do
      commands = [
        Sales::Application::AddItemToOrder.new(order_id: order_id, product_id: product.id),
        Sales::Application::PlaceOrder.new(order_id: order_id, customer_id: customer_id)
      ]
      expected_events = [
        Sales::Domain::ItemAddedToOrder.new(order_id: order_id, product_id: product.id, price: product.price),
        Sales::Domain::OrderPlaced.new(order_id: order_id, customer_id: customer_id, total_price: product.price),
        Sales::Domain::PaymentSucceeded.new(payment_id: payment_id, customer_id: customer_id, order_id: order_id, amount: product.price),
        Sales::Domain::OrderCompleted.new(order_id: order_id)
      ]

      commands.each { |command| command_bus.call(command) }
      expect(event_store).to receive_events(expected_events)
    end
  end

  describe "with failed payment" do
    let(:gateway_response) { Sales::Adapter::Payment::Error.new("Invalid CVV2") }

    it "exipres the order" do
      commands = [
        Sales::Application::AddItemToOrder.new(order_id: order_id, product_id: product.id),
        Sales::Application::PlaceOrder.new(order_id: order_id, customer_id: customer_id)
      ]
      expected_events = [
        Sales::Domain::ItemAddedToOrder.new(order_id: order_id, product_id: product.id, price: product.price),
        Sales::Domain::OrderPlaced.new(order_id: order_id, customer_id: customer_id, total_price: product.price),
        Sales::Domain::PaymentFailed.new(error: "Invalid CVV2", customer_id: customer_id, order_id: order_id, amount: product.price),
        Sales::Domain::OrderCancelled.new(order_id: order_id, reason: "Payment failed")
      ]

      commands.each { |command| command_bus.call(command) }
      expect(event_store).to receive_events(expected_events)
    end
  end
end
