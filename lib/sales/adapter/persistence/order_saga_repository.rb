require_relative 'event_sourced_repository'

module Sales
  module Adapter
    module Persistence
      class OrderSagaRepository < EventSourcedRepository
        def aggregate_class
          OrderSaga
        end
      end
    end
  end
end
