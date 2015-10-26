require 'spec_helper'

RSpec.describe Toot::Auth::ListsCredentials do
  let(:connection) { instance_spy(Redis) }

  before do
    allow(Toot).to receive(:redis) do |&blk|
      blk.call(connection)
    end
  end

  describe "#call" do
    it "calls HKEYS for given store_key" do
      described_class.call(store_key: "store.location")
      expect(connection).to have_received(:hkeys).with("store.location")
    end

    it "returns a list of usernames" do
      allow(connection).to receive(:hkeys).and_return(["a", "b", "c"])
      expect(described_class.call(store_key: "loc")).to eq(["a", "b", "c"])
    end

    it "defaults store_key to Toot.config.auth_credentials_store_key" do
      Toot.config.auth_credentials_store_key = "store-key"
      described_class.call
      expect(connection).to have_received(:hkeys).with("store-key", any_args)
    end
  end

end
