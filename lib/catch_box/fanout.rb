# frozen_string_literal: true

require "dry-configurable"
require "catch_box/event"
require "catch_box/auth"
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

        setting :event, ::CatchBox::Event.new
        setting :auth, ::CatchBox::Auth.new

        setting :on, ::CatchBox::On.new
        setting :emitter, ::CatchBox::Emitter.new

        def config
          self.class.config
        end
      end
    end

    def self.extended(descendant)
      descendant.class_eval do
        extend ::Dry::Configurable

        setting :event, ::CatchBox::Event.new
        setting :auth, ::CatchBox::Auth.new

        setting :on, ::CatchBox::On.new
        setting :emitter, ::CatchBox::Emitter.new

        @_fanout = []
      end
    end

    def event(callable = nil, &block)
      config.event.call(callable || block)
    end

    def auth(callable = nil, &block)
      config.auth.call(callable || block)
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

    def emit(payload, env)
      config.auth.map(payload, env)

      pattern = config.event.map(payload)

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
