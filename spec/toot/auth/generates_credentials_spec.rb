require 'spec_helper'

RSpec.describe Toot::Auth::GeneratesCredentials do
  describe "#call" do
    it "takes the key location of the credential store and an optional name" do
      described_class.call(store_key: "store.location")
      described_class.call(store_key: "store.location", name: "name")
    end

    it "returns an object responding to #username and #password" do
      obj = described_class.call(store_key: "store.location")
      expect(obj.username).to_not be_nil
      expect(obj.password).to_not be_nil
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
  end
end
