require 'spec_helper'

RSpec.describe Toot::Auth::Credentials do

  describe "#initializer" do
    it "sets first argument to #username" do
      obj = described_class.new("un", "pw")
      expect(obj.username).to eq("un")
    end

    it "sets second argument to #password" do
      obj = described_class.new("un", "pw")
      expect(obj.password).to eq("pw")
    end
  end

  describe "#hashed_password" do
    it "returns a SHA2 hashed representation of @password" do
      obj = described_class.new("un", "pw")
      expect(obj.hashed_password).to eq(OpenSSL::Digest::SHA256.digest("pw"))
    end
  end

end
