module Sales
  module Application
    module Order
      class AddItemToOrderCommand < Common::Command
        attribute :order_id,   Types::Coercible::Int
        attribute :product_id, Types::Coercible::Int
      end
    end
  end
end
