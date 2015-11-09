require 'spec_helper'
require 'base64'

RSpec.describe Toot::Auth do
  it 'has a version number' do
    expect(Toot::Auth::VERSION).not_to be nil
  end

  describe "#service_wrapper" do
    it "returns a Basic Auth wrapped around the passed rack app" do
      expect(Rack::Auth::Basic).to receive(:new).with(:app, "Toot Auth").and_return(:protected_app)
      expect(Toot::Auth.service_wrapper(:app)).to eq(:protected_app)
    end

    it "authenticates against ChecksCredentials object" do
      expect(Rack::Auth::Basic).to receive(:new) do |app, realm, &blk|
        expect(Toot::Auth::ChecksCredentials).to receive(:call).with(hash_including(username: "un", password: "pw"))
        blk.call("un", "pw")
      end
      Toot::Auth.service_wrapper(:app)
    end

    it "allows setting store_key" do
      expect(Rack::Auth::Basic).to receive(:new) do |app, realm, &blk|
        expect(Toot::Auth::ChecksCredentials)
          .to receive(:call).with(username: "un", password: "pw", store_key: "test")
        blk.call("un", "pw")
      end
      Toot::Auth.service_wrapper(:app, store_key: "test")
    end

    it "defaults store_key to config value" do
      Toot.config.auth_credentials_store_key = "test"
      expect(Rack::Auth::Basic).to receive(:new) do |app, realm, &blk|
        expect(Toot::Auth::ChecksCredentials)
          .to receive(:call).with(username: "un", password: "pw", store_key: "test")
        blk.call("un", "pw")
      end
      Toot::Auth.service_wrapper(:app)
    end

  end

  describe "#install_client_auth" do
    it "calls #basic_auth on the Faraday connection" do
      Toot.config.auth_username = "un"
      Toot.config.auth_password = "pw"

      expect(Toot.config.http_connection)
        .to receive(:basic_auth).with("un", "pw")

      Toot::Auth.install_client_auth
    end
  end
end
