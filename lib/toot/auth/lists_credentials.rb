module Toot::Auth
  class ListsCredentials

    def call(store_key:)
      Toot.redis do |r|
        r.hkeys store_key
      end
    end

    def self.call(*args)
      new.call(*args)
    end
  end
end
