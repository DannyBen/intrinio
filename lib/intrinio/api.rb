require 'apicake'

module Intrinio
  # Provides access to all the Intrinio API endpoints with dynamic methods
  # anc caching.
  class API < APICake::Base
    base_uri 'https://api.intrinio.com'

    attr_reader :username, :password

    def initialize(opts={})
      if opts[:auth] 
        opts[:username], opts[:password] = opts[:auth].split ':'
        opts.delete :auth
      end

      @username, @password = opts[:username], opts[:password]

      cache.disable unless opts[:use_cache]
      cache.dir = opts[:cache_dir] if opts[:cache_dir]
      cache.life = opts[:cache_life] if opts[:cache_life]
    end

    def default_params
      { basic_auth: { username: username, password: password } }
    end
  end
end