require 'ddd_shop'
require 'support/publish_events_matcher'
require 'support/raise_events_matcher'
require 'sales/setup'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
