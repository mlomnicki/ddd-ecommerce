module Sales
  class OrderSaga
    include Saga

    def initialize(order_id)
      @order_id = order_id
    end

    def handle(event)
      case event
      when Domain::OrderPlaced      then request_payment(event)
      when Domain::PaymentSucceeded then complete_order(event)
      when Domain::PaymentFailed    then cancel_order(event)
      end
    end

    private

    def request_payment(order_placed)
      deliver Application::RequestPayment.new(
        order_id:    order_placed.order_id,
        customer_id: order_placed.customer_id,
        amount:      order_placed.total_price
      )
    end

    def complete_order(payment_succeeded)
      deliver Application::CompleteOrder.new(order_id: payment_succeeded.order_id)
    end

    def cancel_order(payment_failed)
      deliver Application::CancelOrder.new(order_id: payment_failed.order_id, reason: "Payment failed")
    end
  end
end
