require 'super_docopt'
require 'json'
require 'awesome_print'

module Intrinio

  # Handles the command line interface
  class CommandLine < SuperDocopt::Base
    version VERSION
    docopt File.expand_path 'docopt.txt', __dir__
    subcommands ['get', 'pretty', 'see', 'url', 'save']

    attr_reader :path, :params, :file, :csv

    def before_execute
      @path   = args['PATH']
      @params = translate_params args['PARAMS']
      @file   = args['FILE']
      @csv    = args['--csv']

      if intrinio_auth.empty?
        raise Intrinio::MissingAuth, "Missing Authentication\nPlease set INTRINIO_AUTH=username:password"
      end
    end

    def get
      if csv
        puts intrinio.get_csv path, params
      else
        payload = intrinio.get! path, params
        puts payload.response.body
      end
    end

    def save
      if csv
        success = intrinio.save_csv file, path, params
      else
        success = intrinio.save file, path, params
      end
      puts success ? "Saved #{file}" : "Saving failed"
    end

    def pretty
      payload = intrinio.get path, params
      puts JSON.pretty_generate payload
    end

    def see
      ap intrinio.get path, params
    end

    def url
      puts intrinio.url path, params
    end

    # Convert a params array like [key:value, key:value] to a hash like
    # {key: value, key: value}
    def translate_params(pairs)
      result = {}
      return result if pairs.empty?
      pairs.each do |pair|
        key, value = pair.split ':'
        result[key.to_sym] = value
      end
      result
    end

    def intrinio
      @intrinio ||= intrinio!
    end

    private

    def intrinio!
      Intrinio::API.new options
    end

    def options
      result = { username: username, password: password }
      return result unless cache_dir || cache_life
      
      result[:use_cache] = true
      result[:cache_dir] = cache_dir if cache_dir
      result[:cache_life] = cache_life.to_i if cache_life
      result
    end

    def username
      @username ||= intrinio_auth.split(':').first
    end

    def password
      @password ||= intrinio_auth.split(':').last
    end

    def intrinio_auth
      ENV['INTRINIO_AUTH'] || ''
    end

    def cache_dir
      ENV['INTRINIO_CACHE_DIR']
    end

    def cache_life
      ENV['INTRINIO_CACHE_LIFE']
    end

  end
end
