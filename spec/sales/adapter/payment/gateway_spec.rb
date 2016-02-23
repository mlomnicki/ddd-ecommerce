require 'spec_helper'
require 'support/sales_helper'

RSpec.describe Sales::Adapter::Payment::Gateway do
  include SalesHelper

  let(:event_store)  { FakeEventStore.new }
  let(:payment_info) { Sales::Domain::PaymentInfo.new(order_id, customer_id, amount) }

  let(:gateway_response) { Sales::Adapter::Payment::Success.new(SecureRandom.uuid) }
  let(:payment_api)      { Sales::Adapter::Payment::Api.new(gateway_response) }
  let(:gateway)          { described_class.new(event_store, payment_api) }

  describe "successful charge" do
    it "calls Payment API" do
      gateway.process_payment(payment_info)

      expect(payment_api.requests).to eq([payment_info])
    end

    it "publishes PaymentSucceeded" do
      gateway.process_payment(payment_info)

      expect(event_store).to receive_events([
        Sales::Domain::PaymentSucceeded.new(
          payment_id:  gateway_response.payment_id,
          customer_id: customer_id,
          order_id:    order_id,
          amount:      amount
        )
      ])
    end
  end

  describe "failed charge" do
    let(:gateway_response) { Sales::Adapter::Payment::Error.new("Invalid CVV2") }

    it "calls Payment API" do
      gateway.process_payment(payment_info)

      expect(payment_api.requests).to eq([payment_info])
    end

    it "publishes PaymentFailed" do
      gateway.process_payment(payment_info)

      expect(event_store).to receive_events([
        Sales::Domain::PaymentFailed.new(
          error:       gateway_response.error_message,
          customer_id: customer_id,
          order_id:    order_id,
          amount:      amount
        )
      ])
    end
  end
end
