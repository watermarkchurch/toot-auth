require 'spec_helper'

RSpec.describe Toot::Auth::RemovesCredentials do
  let(:connection) { instance_spy(Redis) }

  before do
    allow(Toot).to receive(:redis) do |&blk|
      blk.call(connection)
    end
  end

  describe "#call" do
    it "takes a store_key and a username" do
      described_class.call store_key: "store.location", username: "user123"
    end

    it "calls HDEL on Redis connection for the given username" do
      described_class.call store_key: "store.location", username: "user123"
      expect(connection).to have_received(:hdel).with("store.location", "user123")
    end

    it "defaults store_key to Toot.config.auth_credentials_store_key" do
      Toot.config.auth_credentials_store_key = "store-key"
      described_class.call(username: "un")
      expect(connection).to have_received(:hdel).with("store-key", any_args)
    end
  end
end
