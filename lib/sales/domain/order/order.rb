require_relative 'order_item'

module Sales
  module Domain
    module Order
      class Order
        include Common::AggregateRoot

        AlreadyCreated = Class.new(StandardError)
        MissingItems   = Class.new(StandardError)

        attr_reader :id

        def initialize(id)
          @id    = id
          @state = :draft
          @items = []
        end

        def add_item(product_id)
          check_if_draft
          apply ItemAddedToOrder.new(order_id: id, product_id: product_id)
        end

        def create(customer_id)
          check_if_draft
          check_if_items_available
          apply OrderCreated.new(order_id: id, customer_id: customer_id)
        end

        private
        attr_accessor :state, :customer_id, :items

        def apply_order_created(event)
          @state = :created
        end

        def apply_item_added_to_order(event)
          @items << OrderItem.new(event.product_id)
        end

        def check_if_draft
          raise AlreadyCreated unless state == :draft
        end

        def check_if_items_available
          raise MissingItems if items.empty?
        end
      end
    end
  end
end
