# frozen_string_literal: true

require "catch_box/hook"

module CatchBox
  class Hook
    class One < ::CatchBox::Hook
      def initialize(pattern, hook)
        @pattern = pattern

        super(hook)
      end

      def match?(pattern)
        @pattern == pattern
      end
    end
  end
end
