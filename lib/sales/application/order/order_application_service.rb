module Sales
  module Application
    module Order
      class OrderApplicationService
        UnknownProduct = Class.new(StandardError)

        def initialize(order_repository, product_repository)
          @order_repository   = order_repository
          @product_repository = product_repository
        end

        def add_item_to_order(command)
          product = product_repository.load(command.product_id)

          if product.nil?
            raise UnknownProduct, "Unknown product with ID: #{command.product_id}"
          end

          order_repository.store(command.order_id) do |order|
            order.add_item(product.id, product.price)
          end
        end

        def create_order(command)
          order_repository.store(command.order_id) do |order|
            order.create(command.customer_id)
          end
        end

        def expire_order(command)
          order_repository.store(command.order_id) do |order|
            order.expire
          end
        end

        private

        attr_reader :order_repository, :product_repository
      end
    end
  end
end
