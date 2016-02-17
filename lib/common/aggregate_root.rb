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
      send("apply_#{event_basename(event)}", event)
    end

    def event_basename(event)
      event.class.name.split("::").last.gsub!(/(.)([A-Z])/,'\1_\2').downcase
    end
  end
end
