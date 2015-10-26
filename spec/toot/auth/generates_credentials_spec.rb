require 'spec_helper'

RSpec.describe Toot::Auth::GeneratesCredentials do
  let(:connection) { instance_spy(Redis) }

  before do
    allow(Toot).to receive(:redis) do |&blk|
      blk.call(connection)
    end
  end

  describe "#call" do
    it "takes the key location of the credential store and an optional name" do
      described_class.call(store_key: "store.location")
      described_class.call(store_key: "store.location", name: "name")
    end

    it "calls HSET on the redis connection with the store key" do
      described_class.call(store_key: "store.location")
      expect(connection).to have_received(:hset).with("store.location", anything, anything)
    end

    it "returns an object responding to #username and #password" do
      obj = described_class.call(store_key: "store.location")
      expect(obj.username).to_not be_nil
      expect(obj.password).to_not be_nil
    end

    it "uses a key that is returned in the result" do
      obj = described_class.call(store_key: "store.location")
      expect(connection).to have_received(:hset).with(anything, obj.username, anything)
    end

    it "prefixes username with name option if provided" do
      obj = described_class.call(store_key: "store.location", name: "prefix")
      expect(obj.username).to start_with("prefix")
    end

    it "uses random secure values for username and password" do
      obj1 = described_class.call(store_key: "store.location")
      expect(obj1.username.size).to be > 20
      expect(obj1.password.size).to be > 20

      obj2 = described_class.call(store_key: "store.location")
      expect(obj2.username).to_not eq(obj1.username)
      expect(obj2.password).to_not eq(obj1.password)
    end

    it "uses a value that is a SHA2 version of what is returned in the result" do
      obj = described_class.call(store_key: "store.location")
      hashed = OpenSSL::Digest::SHA256.digest(obj.password)
      expect(connection).to have_received(:hset).with(anything, anything, hashed)
    end
  end
end
