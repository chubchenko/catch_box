# frozen_string_literal: true

require "catch_box/hook/factory"

module CatchBox
  class On
    def call(fanout, pattern, hook)
      fanout << factory.call(pattern, hook)
    end

    private

    def factory
      @factory ||= ::CatchBox::Hook::Factory.new
    end
  end
end
