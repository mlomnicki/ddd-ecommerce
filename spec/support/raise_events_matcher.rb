RSpec::Matchers.define :raise_events do |expected_events|
  match do |aggregate|
    aggregate.unpublished_events == expected_events
  end
end
