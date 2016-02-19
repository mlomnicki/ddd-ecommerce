module Sales
  module Domain
    module Order
      class OrderItem
        attr_reader :product_id, :price

        def initialize(product_id, price)
          @product_id = product_id
          @price      = price
        end
      end
    end
  end
end
