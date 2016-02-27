require_relative 'event_sourced_repository'

module Sales
  module Adapter
    module Persistence
      class OrderRepository < EventSourcedRepository
        def aggregate_class
          Domain::Order
        end
      end
    end
  end
end
