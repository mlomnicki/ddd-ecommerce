module Sales
  module Application
    module Order
      class CreateOrderCommand < Dry::Data::Struct
        attribute :order_id,    Types::Coercible::Int
        attribute :customer_id, Types::Coercible::Int
      end
    end
  end
end
