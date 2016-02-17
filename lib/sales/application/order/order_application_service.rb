module Sales
  module Application
    module Order
      class OrderApplicationService
        def initialize(order_repository, product_price)
          @order_repository = order_repository
          @product_price    = product_price
        end

        def add_item_to_order(command)
          order_repository.store(command.order_id) do |order|
            order.add_item(command.product_id, @product_price)
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

        attr_reader :order_repository
      end
    end
  end
end
