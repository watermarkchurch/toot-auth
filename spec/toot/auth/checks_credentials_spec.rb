require 'spec_helper'

RSpec.describe Toot::Auth::ChecksCredentials do
  let(:connection) { instance_spy(Redis) }

  before do
    allow(Toot).to receive(:redis) do |&blk|
      blk.call(connection)
    end
  end

  describe "#call" do
    it "requires a :store_key, :username, and :password" do
      described_class.call(store_key: "loc", username: "test", password: "test")
      expect { described_class.call(store_key: "loc", username: "test") }.to raise_error(ArgumentError)
      expect { described_class.call(store_key: "loc", password: "test") }.to raise_error(ArgumentError)
      expect { described_class.call(username: "test", password: "test") }.to raise_error(ArgumentError)
    end

    it "returns true if password matches" do
      allow(connection).to receive(:hget).with("loc", "test").and_return(sha2_digest("test"))
      return_value = described_class.call(store_key: "loc", username: "test", password: "test")
      expect(return_value).to be_truthy
    end

    it "returns false if password does not match" do
      allow(connection).to receive(:hget).with("loc", "test").and_return(sha2_digest("secret"))
      return_value = described_class.call(store_key: "loc", username: "test", password: "test")
      expect(return_value).to be_falsey
    end

    it "returns false if password is empty" do
      allow(connection).to receive(:hget).with("loc", "test").and_return(sha2_digest(""))
      return_value = described_class.call(store_key: "loc", username: "test", password: "")
      expect(return_value).to be_falsey
    end

    it "returns false if username is empty" do
      allow(connection).to receive(:hget).with("loc", "").and_return(sha2_digest("foo"))
      return_value = described_class.call(store_key: "loc", username: "", password: "foo")
      expect(return_value).to be_falsey
    end
  end

  def sha2_digest(value)
    OpenSSL::Digest::SHA256.digest(value)
  end

end
