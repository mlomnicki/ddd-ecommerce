require 'spec_helper'
require 'support/sales_helper'

RSpec.describe Sales::Application::PaymentApplicationService do
  include SalesHelper

  let(:event_store)      { FakeEventStore.new }
  let(:gateway_response) { Sales::Adapter::Payment::Success.new(payment_id) }
  let(:payment_api)      { Sales::Adapter::Payment::Api.new(gateway_response) }
  let(:payment_gateway)  { Sales::Adapter::Payment::Gateway.new(event_store, payment_api) }

  let(:request_payment) do
    Sales::Application::RequestPayment.new(order_id: order_id, customer_id: customer_id, amount: amount)
  end

  let(:service) { described_class.new(payment_gateway) }

  it "processes payments" do
    service.request_payment(request_payment)

    expect(event_store).to receive_events([
      Sales::Domain::PaymentSucceeded.new(
        payment_id:  payment_id,
        customer_id: customer_id,
        order_id:    order_id,
        amount:      amount
      )
    ])
  end
end
