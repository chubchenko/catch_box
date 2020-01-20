# frozen_string_literal: true

require "rack/request"
require "rack/utils"

module CatchBox
  class Middleware
    def initialize(app, fanout:, endpoint:)
      @app = app
      @fanout = fanout
      @endpoint = endpoint
    end

    def call(env)
      dup.call!(env)
    end

    protected

    def call!(env)
      request = ::Rack::Request.new(env)

      return @app.call(env) unless request.post?
      return @app.call(env) unless request.path == @endpoint

      body = (
        request.body.rewind
        request.body.read
      )

      payload = ::Rack::Utils.parse_query(body) if request.content_type == "application/x-www-form-urlencoded"
      payload = ::JSON.parse(body) if %r{application/json}i.match?(request.content_type)

      @fanout.emit(payload, request.env)

      [
        200,
        {},
        []
      ]
    rescue ::CatchBox::NotAuthorized
      [
        400,
        {},
        []
      ]
    end
  end
end
