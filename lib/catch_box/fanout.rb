require "dry-configurable"
require "catch_box/on"
require "catch_box/emitter"

module CatchBox
  module Fanout
    module Initialize
      def initialize
        @_fanout = []

        super
      end
    end

    def self.included(descendant)
      descendant.class_eval do
        extend ::Dry::Configurable
        prepend ::CatchBox::Fanout::Initialize

        setting :on, ::CatchBox::On.new
        setting :emit, ::CatchBox::Emit.new

        def config
          self.class.config
        end
      end
    end

    def self.extended(descendant)
      descendant.class_eval do
        extend ::Dry::Configurable

        setting :on, ::CatchBox::On.new
        setting :emitter, ::CatchBox::Emitter.new

        @_fanout = []
      end
    end

    def on(pattern, callable = nil, &block)
      config.on.call(
        _fanout, pattern, callable || block
      )
    end

    def all(callable = nil, &block)
      config.on.call(
        _fanout, nil, callable || block
      )
    end

    def emit(pattern, payload)
      config.emitter.call(
        _fanout, pattern, payload
      )
    end

    private

    def _fanout
      @_fanout
    end
  end
end
