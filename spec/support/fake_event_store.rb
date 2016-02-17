class FakeEventStore
  attr_reader :events, :published

  def initialize
    @events = []
    @published = []
  end

  def publish_event(event, _aggregate_id)
    events << event
    published << event
  end

  def read_all_events(_aggregate_id)
    events
  end
end
