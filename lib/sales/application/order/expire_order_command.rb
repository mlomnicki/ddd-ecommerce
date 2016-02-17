module Sales
  module Application
    module Order
      class ExpireOrderCommand < Common::Command
        attribute :order_id, Types::Coercible::Int
      end
    end
  end
end
