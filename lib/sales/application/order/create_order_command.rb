module Sales
  module Application
    module Order
      class CreateOrderCommand < Common::Command
        attribute :order_id,    Types::Coercible::Int
        attribute :customer_id, Types::Coercible::Int
      end
    end
  end
end
