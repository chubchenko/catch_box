# frozen_string_literal: true

module CatchBox
  NotAuthorized = ::Class.new(::StandardError)

  class Auth
    def initialize(auth: proc { false })
      @auth = auth
    end

    def call(auth)
      @auth = auth
    end

    def map(payload, env)
      return if @auth.call(payload, env)

      raise ::CatchBox::NotAuthorized
    end
  end
end
