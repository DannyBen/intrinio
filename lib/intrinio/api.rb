require 'json'

module Intrinio
  # Provides access to all the Intrinio API endpoints
  class API < WebAPI
    attr_reader :opts

    def initialize(opts={})
      defaults = {
        username: nil,
        password: nil,
        use_cache: false,
        cache_dir: nil,
        cache_life: nil,
        base_url: "https://api.intrinio.com"
      }

      opts = defaults.merge! opts
      @opts = opts

      username, password = opts[:username], opts[:password]

      cache.disable unless opts[:use_cache]
      cache.dir = opts[:cache_dir] if opts[:cache_dir]
      cache.life = opts[:cache_life] if opts[:cache_life]
      cache.options[:http_basic_authentication] = [username, password]

      after_request do |response| 
        begin
          JSON.parse response, symbolize_names: true
        rescue JSON::ParserError
          response
        end
      end
      
      super opts[:base_url]
    end
  end
end