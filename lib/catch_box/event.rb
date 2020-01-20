# frozen_string_literal: true

module CatchBox
  class Event
    DELIMITER = "."

    def initialize
      @name = nil
    end

    def call(name)
      @name = name
    end

    def map(payload)
      payload.dig(*@name.split(DELIMITER))
    end
  end
end
