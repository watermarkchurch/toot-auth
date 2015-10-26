require 'spec_helper'

RSpec.describe Toot::Auth do
  it 'has a version number' do
    expect(Toot::Auth::VERSION).not_to be nil
  end

  describe "#wrapper" do
    it "returns a Basic Auth wrapped around the passed rack app" do
      expect(Rack::Auth::Basic).to receive(:new).with(:app, "Toot Auth").and_return(:protected_app)
      expect(Toot::Auth.wrapper(:app)).to eq(:protected_app)
    end

    it "authenticates against ChecksCredentials object" do
      expect(Rack::Auth::Basic).to receive(:new) do |app, realm, &blk|
        expect(Toot::Auth::ChecksCredentials).to receive(:call).with(hash_including(username: "un", password: "pw"))
        blk.call("un", "pw")
      end
      Toot::Auth.wrapper(:app)
    end

    it "allows setting store_key" do
      expect(Rack::Auth::Basic).to receive(:new) do |app, realm, &blk|
        expect(Toot::Auth::ChecksCredentials)
          .to receive(:call).with(username: "un", password: "pw", store_key: "test")
        blk.call("un", "pw")
      end
      Toot::Auth.wrapper(:app, store_key: "test")
    end

    it "defaults store_key to config value" do
      Toot.config.auth_credentials_store_key = "test"
      expect(Rack::Auth::Basic).to receive(:new) do |app, realm, &blk|
        expect(Toot::Auth::ChecksCredentials)
          .to receive(:call).with(username: "un", password: "pw", store_key: "test")
        blk.call("un", "pw")
      end
      Toot::Auth.wrapper(:app)
    end

  end
end
