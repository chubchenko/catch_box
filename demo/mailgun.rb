require 'catch_box'
require 'logger'

# ======================================================================================================================

module Mailgun
  class Delivered
    def initialize(logger: ::Logger.new(::STDOUT))
      @logger = logger
    end

    def call(payload)
      @logger.info(payload)
    end
  end

  class Fanout
    extend ::CatchBox::Fanout

    on "delivered", ::Mailgun::Delivered.new

    all do |payload|
      ::Logger.new(::STDOUT).info(payload)
    end
  end
end

# ======================================================================================================================

require 'rack/lobster'

Application = Rack::Builder.new do
  use ::CatchBox::Middleware, fanout: ::Mailgun::Fanout, endpoint: '/mailgun'

  map '/' do
    run(
      proc do
        [200, { 'Content-Type' => 'text/plain' }, ['o_O']]
      end
    )
  end
end

Rack::Handler::WEBrick.run(Application)
