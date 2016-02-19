require "dry/data"
require "common/money"
require 'common/aggregate_root'
require 'common/value_object'
require 'common/event'
require 'common/command'

module Types
end

Dry::Data.configure do |config|
  config.namespace = Types
end

Dry::Data.finalize
