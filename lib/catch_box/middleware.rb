require "rack/request"

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

      payload = (
        request.body.rewind
        request.body.read
      )

      @fanout.emit(request.params.fetch('event'), payload)

      [
        200,
        {},
        []
      ]
    end
  end
end
