module Sales
  module Adapter
    module Persistence
      class ProductRepository
        def initialize(products = [])
          @products = products
        end

        def load(product_id)
          @products.find { |product| product.id == product_id }
        end
      end
    end
  end
end
