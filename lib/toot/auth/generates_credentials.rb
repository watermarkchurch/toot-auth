module Toot::Auth
  class GeneratesCredentials

    GENERATES_USERNAME = -> (prefix) { prefix + SecureRandom.hex }
    GENERATES_PASSWORD = -> { SecureRandom.hex }

    class Credential < Struct.new(:username, :password)
      def hashed_password
        OpenSSL::Digest::SHA256.digest(password)
      end
    end

    def call(store_key:, name: "")
      credential = Credential.new GENERATES_USERNAME.(name), GENERATES_PASSWORD.()

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