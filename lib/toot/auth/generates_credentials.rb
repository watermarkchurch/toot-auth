module Toot::Auth
  class GeneratesCredentials

    GENERATES_USERNAME = -> (prefix) { prefix + SecureRandom.hex }
    GENERATES_PASSWORD = -> { SecureRandom.hex }

    def call(store_key:, name: "")
      Credentials.new GENERATES_USERNAME.(name), GENERATES_PASSWORD.()
    end

    def self.call(*args)
      new.call(*args)
    end

  end
end
