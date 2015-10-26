module Toot::Auth
  class AddsCredentials

    def call(store_key:, credentials:)
      Toot.redis do |r|
        r.hset store_key, credentials.username, credentials.hashed_password
      end
    end

    def self.call(*args)
      new.call(*args)
    end
  end
end
