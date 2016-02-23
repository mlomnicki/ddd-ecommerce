require 'spec_helper'
require 'support/sales_helper'

RSpec.describe Sales::OrderSaga do
  include SalesHelper

  let(:saga) { described_class.new }

  describe "if order was placed" do
    it "requests a payment" do
      saga.handle(Sales::Domain::OrderPlaced.new(order_id: order_id, customer_id: customer_id, total_price: amount))

      expect(saga.unprocessed_commands).to eq([
        Sales::Application::RequestPayment.new(order_id: order_id, amount: amount)
      ])
    end
  end

  describe "if payment succeeded" do
    it "completes order" do
      saga.handle(
        Sales::Domain::PaymentSucceeded.new(order_id: order_id, payment_id: payment_id, customer_id: customer_id, amount: amount)
      )

      expect(saga.unprocessed_commands).to eq([
        Sales::Application::CompleteOrder.new(order_id: order_id)
      ])
    end
  end

  describe "if payment failed" do
    it "expires order" do
      saga.handle(Sales::Domain::PaymentFailed.new(order_id: order_id, customer_id: customer_id, amount: amount, error: "Invalid CVV2"))

      expect(saga.unprocessed_commands).to eq([
        Sales::Application::ExpireOrder.new(order_id: order_id)
      ])
    end
  end
end
