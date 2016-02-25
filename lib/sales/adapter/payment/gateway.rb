require_relative 'responses'

module Sales
  module Adapter
    module Payment
      class Gateway
        def initialize(event_store, api)
          @event_store = event_store
          @api         = api
        end

        def process_payment(payment_info)
          gateway_result = api.process_payment(payment_info)
          payment_succeeded(payment_info, gateway_result)
        rescue ApiFailure => error
          payment_failed(payment_info, error.message)
        end

        private

        attr_reader :event_store, :api

        def payment_succeeded(payment_info, gateway_result)
          publish_event(
            Domain::PaymentSucceeded.new(
              payment_id:  gateway_result.payment_id,
              order_id:    payment_info.order_id,
              customer_id: payment_info.customer_id,
              amount:      payment_info.amount
            )
          )
        end

        def payment_failed(payment_info, error_message)
          publish_event(
            Domain::PaymentFailed.new(
              error:       error_message,
              customer_id: payment_info.customer_id,
              order_id:    payment_info.order_id,
              amount:      payment_info.amount
            )
          )
        end

        def publish_event(event)
          event_store.publish_event(event, stream_name(event.order_id))
        end

        def stream_name(order_id)
          "order-payment$#{order_id}"
        end
      end
    end
  end
end
