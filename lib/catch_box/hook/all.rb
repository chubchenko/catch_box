require "catch_box/hook"

module CatchBox
  class Hook
    class All < ::CatchBox::Hook
      def match?(_pattern)
        true
      end
    end
  end
end
