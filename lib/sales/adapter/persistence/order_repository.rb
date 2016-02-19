require_relative 'abstract_repository'

module Sales
  module Adapter
    module Persistence
      class OrderRepository < AbstractRepository
        def aggregate_class
          Domain::Order
        end
      end
    end
  end
end
