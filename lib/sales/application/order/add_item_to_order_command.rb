module Sales
  module Application
    module Order
      class AddItemToOrderCommand < Dry::Data::Struct
        attribute :order_id,   Types::Coercible::Int
        attribute :product_id, Types::Coercible::Int
      end
    end
  end
end
