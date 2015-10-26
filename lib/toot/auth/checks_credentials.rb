module Toot::Auth
  class ChecksCredentials

    def call(store_key:, username:, password:)
      return false if username.empty? || password.empty?
      stored_password(store_key, username) ==
        Credentials.new(username, password).hashed_password
    end

    private def stored_password(store_key, username)
      Toot.redis { |r| r.hget(store_key, username) }
    end

    def self.call(*args)
      new.call(*args)
    end

  end
end
