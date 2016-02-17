module Sales
  module Domain
    module Order
      class Order
        include Common::AggregateRoot

        AlreadyCreated = Class.new(StandardError)

        attr_reader :id

        def initialize(id)
          @id = id
          @state = :draft
        end

        def create(customer_id)
          check_if_draft
          apply OrderCreated.new(order_id: id, customer_id: customer_id)
        end

        private
        attr_accessor :state, :customer_id

        def apply_order_created(event)
          @state = :created
        end

        def check_if_draft
          raise AlreadyCreated unless state == :draft
        end
      end
    end
  end
end
