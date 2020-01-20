# frozen_string_literal: true

module CatchBox
  class Emitter
    def call(fanout, pattern, payload)
      fanout.select { |hook|
        hook.match?(pattern)
      }.each do |hook|
        hook.call(payload)
      end
    end
  end
end
