module Sales
  class OrderSaga
    def handle(event)
      case event
      when Domain::OrderPlaced      then request_payment(event)
      when Domain::PaymentSucceeded then complete_order(event)
      when Domain::PaymentFailed    then expire_order(event)
      end
    end

    def unprocessed_commands
      @unprocessed_commands ||= []
    end

    private

    def request_payment(order_placed)
      deliver Application::RequestPayment.new(order_id: order_placed.order_id, amount: order_placed.total_price)
    end

    def complete_order(payment_succeeded)
      deliver Application::CompleteOrder.new(order_id: payment_succeeded.order_id)
    end

    def expire_order(payment_failed)
      deliver Application::ExpireOrder.new(order_id: payment_failed.order_id)
    end

    def deliver(command)
      unprocessed_commands << command
    end
  end
end
