module Sales
  module Domain
    class PaymentInfo
      attr_reader :order_id, :customer_id, :amount

      def initialize(order_id, customer_id, amount)
        @order_id    = order_id
        @customer_id = customer_id
        @amount      = amount
      end
    end
  end
end
