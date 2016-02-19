module Sales
  module Application
    module Order
      class ExpireOrderCommand < Command
        attribute :order_id, Types::Coercible::Int
      end
    end
  end
end
