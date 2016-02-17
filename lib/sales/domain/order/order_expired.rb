module Sales
  module Domain
    module Order
      class OrderExpired < Common::Event
        attribute :order_id, Types::Int
      end
    end
  end
end
