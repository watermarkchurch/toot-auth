module Toot::Auth
  class RemovesCredentials

    def call(store_key: Toot.config.auth_credentials_store_key, username:)
      Toot.redis do |r|
        r.hdel store_key, username
      end
    end

    def self.call(*args)
      new.call(*args)
    end

  end
end
