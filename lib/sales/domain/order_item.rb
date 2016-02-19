module Sales
  module Domain
    class OrderItem
      attr_reader :product_id, :price

      def initialize(product_id, price)
        @product_id = product_id
        @price      = price
      end
    end
  end
end
