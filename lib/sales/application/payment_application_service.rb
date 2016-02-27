module Sales
  module Application
    class PaymentApplicationService
      def initialize(payment_gateway)
        @payment_gateway = payment_gateway
      end

      def request_payment(command)
        payment = Domain::PaymentInfo.new(command.order_id, command.customer_id, command.amount)
        @payment_gateway.process_payment(payment)
      end
    end
  end
end
