module Sales
  module Domain
    module Order
      class OrderItem
        attr_reader :product_id

        def initialize(product_id)
          @product_id = product_id
        end
      end
    end
  end
end
