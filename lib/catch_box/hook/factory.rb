# frozen_string_literal: true

require "catch_box/hook/all"
require "catch_box/hook/one"

module CatchBox
  class Hook
    class Factory
      def call(pattern, hook)
        if pattern.nil?
          ::CatchBox::Hook::All.new(hook)
        else
          ::CatchBox::Hook::One.new(pattern, hook)
        end
      end
    end
  end
end
