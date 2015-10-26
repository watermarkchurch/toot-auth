require 'spec_helper'

RSpec.describe Toot::Auth::AddsCredentials do
  let(:connection) { instance_spy(Redis) }

  before do
    allow(Toot).to receive(:redis) do |&blk|
      blk.call(connection)
    end
  end

  describe "#call" do
    it "calls HSET on the redis connection with the credentials" do
      described_class.call(store_key: "loc", credentials: Toot::Auth::Credentials.new("un", "pw"))
      hashed = OpenSSL::Digest::SHA256.digest("pw")
      expect(connection).to have_received(:hset).with("loc", "un", hashed)
    end

    it "defaults store_key to Toot.config.auth_credentials_store_key" do
      Toot.config.auth_credentials_store_key = "store-key"
      described_class.call(credentials: Toot::Auth::Credentials.new("un", "pw"))
      expect(connection).to have_received(:hset).with("store-key", any_args)
    end
  end

end
