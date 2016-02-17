module Sales
  module Application
    module Order
      class OrderApplicationService
        def initialize(order_repository)
          @order_repository = order_repository
        end

        def add_item_to_order(command)
          order_repository.store(command.order_id) do |order|
            order.add_item(command.product_id)
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
