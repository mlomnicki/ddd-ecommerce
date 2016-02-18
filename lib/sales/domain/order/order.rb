require_relative 'order_item'

module Sales
  module Domain
    module Order
      class Order
        include Common::AggregateRoot

        AlreadyPlaced = Class.new(StandardError)
        MissingItems  = Class.new(StandardError)

        attr_reader :id

        def initialize(id)
          @id    = id
          @state = :draft
          @items = []
        end

        def add_item(product_id, price)
          check_if_draft
          apply ItemAddedToOrder.new(order_id: id, price: price.amount_in_cents, product_id: product_id)
        end

        def place(customer_id)
          check_if_draft
          check_if_items_available
          apply OrderPlaced.new(order_id: id, customer_id: customer_id)
        end

        def expire
          check_if_draft
          apply OrderExpired.new(order_id: id)
        end

        private

        attr_accessor :state, :customer_id, :items

        def apply_order_placed(_event)
          @state = :placed
        end

        def apply_order_expired(_event)
          @state = :expired
        end

        def apply_item_added_to_order(event)
          @items << OrderItem.new(event.product_id)
        end

        def check_if_draft
          raise AlreadyPlaced unless state == :draft
        end

        def check_if_items_available
          raise MissingItems if items.empty?
        end
      end
    end
  end
end
