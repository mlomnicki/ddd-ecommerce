class FakeEventStore
  attr_reader :events, :published

  def initialize
    @published   = []
    @streams     = Hash.new { |hash, stream| hash[stream] = [] }
    @subscribers = Hash.new { |hash, event_type| hash[event_type] = [] }
  end

  def publish_event(event, stream_name)
    published << event
    @streams[stream_name] << event
    @subscribers[event.class].each { |subscriber| subscriber.handle(event) }
  end

  def read_all_events(stream_name)
    @streams[stream_name]
  end

  def subscribe(subscriber, event_types)
    event_types.each do |event_type|
      @subscribers[event_type] << subscriber
    end
  end
end
