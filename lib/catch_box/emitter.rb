module CatchBox
  class Emitter
    def call(fanout, pattern, payload)
      fanout.select do |hook|
        hook.match?(pattern)
      end.each do |hook|
        hook.call(payload)
      end
    end
  end
end
