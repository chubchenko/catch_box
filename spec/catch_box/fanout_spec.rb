# frozen_string_literal: true
# frozen_string_literal: trues

RSpec.describe CatchBox::Fanout do
  let(:app) do
    builder =
      ::Rack::Builder.new {
        run(
          proc do
            [200, {"Content-Type" => "text/plain"}, ["o_O"]]
          end
        )
      }
    builder.use(::CatchBox::Middleware, fanout: fanout, endpoint: "/mailgun")

    builder
  end

  describe "extended" do
    let(:klass) do
      Class.new { extend ::CatchBox::Fanout }
    end
    let(:fanout) do
      klass.event "event-data.event"
      klass.auth do |payload, env|
        !payload["signature"]["timestamp"].nil?
      end
      klass.on("delivered", delivered)
      klass.all(all)
      klass
    end

    it_behaves_like "a fanout"
  end

  describe "included" do
    let(:klass) do
      Class.new { include ::CatchBox::Fanout }
    end
    let(:fanout) do
      fanout = klass.new

      fanout.event "event-data.event"
      fanout.auth do |payload, env|
        !payload["signature"]["timestamp"].nil?
      end
      fanout.on("delivered", delivered)
      fanout.all(all)
      fanout
    end

    it_behaves_like "a fanout"
  end
end
