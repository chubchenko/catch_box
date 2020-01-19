module CatchBox
  class Hook
    def initialize(hook)
      @hook = hook
    end

    def call(payload)
      @hook.call(payload)
    end

    def match?(pattern); end
  end
end
