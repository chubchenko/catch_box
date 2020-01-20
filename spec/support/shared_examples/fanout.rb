# frozen_string_literal: true

RSpec.shared_examples "a fanout" do
  let(:delivered) { proc {} }
  let(:all) { proc {} }
  let(:payload) { fixture("delivered.json") }

  context "when the signature comparison is successful" do
    before do
      allow(delivered).to receive(:call)
      allow(all).to receive(:call)
    end

    context "when the event type is delivered" do
      it do
        post("/mailgun", payload.to_json, "CONTENT_TYPE" => "application/json")

        expect(delivered).to have_received(:call).with(
          payload
        ).once
      end

      it do
        post("/mailgun", payload.to_json, "CONTENT_TYPE" => "application/json")

        expect(all).to have_received(:call).with(
          payload
        ).once
      end
    end

    context "when the event type is not delivered" do
      before { payload["event-data"]["event"] = "unsubscribed" }

      it do
        post("/mailgun", payload.to_json, "CONTENT_TYPE" => "application/json")

        expect(delivered).not_to have_received(:call)
      end

      it do
        post("/mailgun", payload.to_json, "CONTENT_TYPE" => "application/json")

        expect(all).to have_received(:call).with(
          payload
        ).once
      end
    end
  end

  context "when the signature comparison is unsuccessful" do
    before { payload["signature"]["timestamp"] = nil }

    it do
      post("/mailgun", payload.to_json, "CONTENT_TYPE" => "application/json")
      expect(last_response).to be_bad_request
    end
  end
end
