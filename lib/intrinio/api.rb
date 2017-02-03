require 'json'
require 'csv'

module Intrinio
  # Provides access to all the Intrinio API endpoints
  class API < WebAPI
    attr_reader :opts

    def initialize(opts={})
      if opts[:auth] 
        opts[:username], opts[:password] = opts[:auth].split ':'
        opts.delete :auth
      end

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

    def get_csv(*args)
      result = get *args

      raise Intrinio::BadResponse, "API said '#{result}'" if result.is_a? String
      raise Intrinio::BadResponse, "Got a #{result.class}, expected a Hash" unless result.is_a? Hash
      raise Intrinio::IncompatibleResponse, "There is no data attribute in the response" unless result.has_key? :data
      raise Intrinio::IncompatibleResponse, "The data attribute in the response is empty" unless result[:data]
      
      data = result[:data]

      header = data.first.keys
      result = CSV.generate do |csv|
        csv << header
        data.each { |row| csv << row.values }
      end

      result
    end

    def save_csv(file, *args)
      data = get_csv *args
      File.write file, data
    end
  end
end