require "common/money"
require "dry/data"

module Types
end

Dry::Data.configure do |config|
  config.namespace = Types
end

Dry::Data.finalize
