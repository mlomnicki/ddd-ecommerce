module Sales
  module Adapter
    module Persistence
      class EventSourcedRepository
        def initialize(event_store)
          @event_store = event_store
        end

        def aggregate_class
          raise NotImplementedError, "Repositories must define 'aggregate_class'"
        end

        def load(aggregate_id)
          aggregate_class.new(aggregate_id).tap do |aggregate|
            events = event_store.read_all_events(aggregate_id)
            events.each do |event|
              aggregate.apply_old_event(event)
            end
          end
        end

        def save(aggregate)
          aggregate.unpublished_events.each do |event|
            event_store.publish_event(event, aggregate.id)
          end
        end

        def store(aggregate_id)
          aggregate = load(aggregate_id)
          yield aggregate
          save(aggregate)
        end

        private

        attr_reader :event_store
      end
    end
  end
end
