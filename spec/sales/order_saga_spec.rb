require 'spec_helper'

RSpec.describe Sales::OrderSaga do
  let(:saga_id)    { 10 }
  let(:order_id)   { 3 }
  let(:payment_id) { 3021 }

  let(:saga) { described_class.new }

  describe "if order was placed" do
    it "requests a payment" do
      total_price = Money.from_float(15.30)

      saga.handle(Sales::Domain::OrderPlaced.new(order_id: order_id, customer_id: 10, total_price: total_price))

      expect(saga.unprocessed_commands).to eq([
        Sales::Application::RequestPayment.new(order_id: order_id, amount: total_price)
      ])
    end
  end

  describe "if payment succeeded" do
    it "completes order" do
      saga.handle(Sales::Domain::PaymentSucceeded.new(order_id: order_id, payment_id: payment_id))

      expect(saga.unprocessed_commands).to eq([
        Sales::Application::CompleteOrder.new(order_id: order_id)
      ])
    end
  end

  describe "if payment failed" do
    it "expires order" do
      saga.handle(Sales::Domain::PaymentFailed.new(order_id: order_id, payment_id: payment_id))

      expect(saga.unprocessed_commands).to eq([
        Sales::Application::ExpireOrder.new(order_id: order_id)
      ])
    end
  end
end
