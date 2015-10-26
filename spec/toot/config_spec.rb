require 'spec_helper'

RSpec.describe Toot::Config do
  subject(:config) { described_class.new }

  describe "#auth_credentials_store_key" do
    it "allows getting and setting" do
      config.auth_credentials_store_key = :foo
      expect(config.auth_credentials_store_key).to eq(:foo)
    end

    it "defaults to 'toot.auth.credentials_store' prefixed by channel_prefix" do
      config.channel_prefix = "prefix.test."
      expect(config.auth_credentials_store_key).to eq("prefix.test.toot.auth.credentials_store")
    end
  end

  describe "#auth_username" do
    it "allows getting and setting" do
      config.auth_username = "username"
      expect(config.auth_username).to eq("username")
    end
  end

  describe "#auth_password" do
    it "allows getting and setting" do
      config.auth_password = "secret"
      expect(config.auth_password).to eq("secret")
    end
  end
end
