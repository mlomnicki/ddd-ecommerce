require 'securerandom'

module Common
  class Event < Dry::Data::Value
    def id
      SecureRandom.uuid
    end
  end
end
