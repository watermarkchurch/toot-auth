module Toot::Auth
  class GeneratesCredentials

    GENERATES_USERNAME = -> (prefix) { prefix + SecureRandom.hex }
    GENERATES_PASSWORD = -> { SecureRandom.hex }

    def call(store_key:, name: "")
      credential = Credentials.new GENERATES_USERNAME.(name), GENERATES_PASSWORD.()

      Toot.redis do |r|
        r.hset store_key, credential.username, credential.hashed_password
      end

      credential
    end

    def self.call(*args)
      new.call(*args)
    end

  end
end
