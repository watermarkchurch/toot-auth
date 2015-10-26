require "toot/auth/version"

require 'toot'

require 'toot/auth/credentials'

require 'toot/auth/checks_credentials'
require 'toot/auth/generates_credentials'
require 'toot/auth/lists_credentials'
require 'toot/auth/removes_credentials'


module Toot
  class Config
    attr_accessor :auth_credentials_store_key

    def auth_credentials_store_key
      @auth_credentials_store_key ||= [channel_prefix, "toot.auth.credentials_store"].join
    end
  end

  module Auth

    def self.wrapper(app, store_key: Toot.config.auth_credentials_store_key)
      Rack::Auth::Basic.new(app, "Toot Auth") do |username, password|
        ChecksCredentials.(username: username, password: password, store_key: store_key)
      end
    end

  end
end
