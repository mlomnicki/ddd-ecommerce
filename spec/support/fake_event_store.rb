class FakeEventStore
  attr_reader :events, :published

  def initialize
    @published = []
    @streams = Hash.new { |hash, stream| hash[stream] = [] }
  end

  def publish_event(event, stream)
    published << event
    @streams[stream] << event
  end

  def read_all_events(stream)
    @streams[stream]
  end
end
