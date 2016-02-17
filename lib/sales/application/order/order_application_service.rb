module Sales
  module Application
    module Order
      class OrderApplicationService
        def initialize(order_repository)
          @order_repository = order_repository
        end

        def add_item_to_order(command)
          with_aggregate(command) do |order|
            order.add_item(command.product_id)
          end
        end

        def create_order(command)
          with_aggregate(command) do |order|
            order.create(command.customer_id)
          end
        end

        def expire_order(command)
          with_aggregate(command) do |order|
            order.expire
          end
        end

        private

        def with_aggregate(command)
          order = @order_repository.load(command.order_id)
          yield order
          @order_repository.save(order)
        end
      end
    end
  end
end
