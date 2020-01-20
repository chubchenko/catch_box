# frozen_string_literal: true

require "catch_box"
require "logger"
require "openssl"

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

  class Auth
    def initialize(api_key: ENV["MAILGUN_API_KEY"])
      @api_key = api_key
    end

    def call(payload, env)
      payload["signature"] == \
        ::OpenSSL::HMAC.hexdigest(
          ::OpenSSL::Digest::SHA256.new,
          api_key,
          [payload["timestamp"], payload["token"]].join
        )
    end

    private

    attr_reader :api_key
  end

  class Fanout
    extend ::CatchBox::Fanout

    event "event"

    auth ::Mailgun::Auth.new

    on "delivered", ::Mailgun::Delivered.new

    all do |payload|
      ::Logger.new(::STDOUT).info(payload)
    end
  end
end

# ======================================================================================================================

require "rack/lobster"

Application = Rack::Builder.new {
  use ::CatchBox::Middleware, fanout: ::Mailgun::Fanout, endpoint: "/mailgun"

  map "/" do
    run(
      proc do
        [200, {"Content-Type" => "text/plain"}, ["o_O"]]
      end
    )
  end
}

Rack::Handler::WEBrick.run(Application)
