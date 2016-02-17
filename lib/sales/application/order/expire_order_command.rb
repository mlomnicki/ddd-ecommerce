module Sales
  module Application
    module Order
      class ExpireOrderCommand < Dry::Data::Struct
        attribute :order_id, Types::Coercible::Int
      end
    end
  end
end
