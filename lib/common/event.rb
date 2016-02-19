require 'securerandom'

module Common
  class Event < ValueObject
    def id
      SecureRandom.uuid
    end

    def event_type
      self.class.name.split("::").last
    end
  end
end
