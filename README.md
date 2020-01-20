[![Gem Version](https://badge.fury.io/rb/catch_box.svg)](https://badge.fury.io/rb/catch_box)
[![RSpec](https://github.com/chubchenko/catch_box/workflows/RSpec/badge.svg)](https://github.com/chubchenko/catch_box/actions)

# Catch Box

A lightweight and straightforward system for easy hooks set up.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem "catch_box", "~> 0.1.0"
```

And then execute:

```bash
bundle
```

## Usage

### Base

> Define fanout

```ruby
require "catch_box/fanout"

class Delivered
  def initialize(logger: Logger.new)
    @logger = logger
  end

  def call(payload)
    @logger.info(payload)
  end
end

class Fanout
  extend ::CatchBox::Fanout

  event "event-data.event"

  auth do |payload, env|
    # https://documentation.mailgun.com/en/latest/user_manual.html#webhooks
    payload["signature"]["signature"] == \
      ::OpenSSL::HMAC.hexdigest(
        ::OpenSSL::Digest::SHA256.new,
        ENV["MAILGUN_API_KEY"],
        [payload["signature"]["timestamp"], payload["signature"]["token"]].join
      )
  end

  on "delivered", Delivered.new

  all do |payload|
    ::Logger.new(::STDOUT).info(payload)
  end
end
```

> Use middleware

```ruby
require "sinatra/base"
require "catch_box/middleware"

class Application < Sinatra::Base
  use ::CatchBox::Middleware, fanout: Fanout, endpoint: "/mailgun"

  get "/" do
    "index"
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chubchenko/catch_box.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
