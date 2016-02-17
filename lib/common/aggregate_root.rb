module Common
  module AggregateRoot
    def apply(event)
      unpublished_events << event
      apply_event(event)
    end

    def apply_old_event(event)
      apply_event(event)
    end

    def unpublished_events
      @unpublished_events ||= []
    end

    private

    def apply_event(event)
      send("apply_#{event_type_underscored(event)}", event)
    end

    def event_type_underscored(event)
      event.event_type.gsub!(/(.)([A-Z])/, '\1_\2').downcase
    end
  end
end
