module Toot::Auth
  class Credentials < Struct.new(:username, :password)

    def hashed_password
      OpenSSL::Digest::SHA256.digest(password)
    end

  end
end
