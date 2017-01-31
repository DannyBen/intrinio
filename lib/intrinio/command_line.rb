require 'singleton'
require 'docopt'
require 'json'
require 'awesome_print'

module Intrinio

  # Handles the command line interface
  class CommandLine
    include Singleton

    # Gets an array of arguments (e.g. ARGV), executes the command if valid
    # and shows usage patterns / help otherwise.
    def execute(argv=[])
      doc = File.read File.dirname(__FILE__) + '/docopt.txt'
      begin
        args = Docopt::docopt(doc, argv: argv, version: VERSION)
        handle args
      rescue Docopt::Exit, Intrinio::MissingAuth => e
        puts e.message
      end
    end

    def intrinio
      @intrinio ||= intrinio!
    end

    private

    attr_reader :path, :params, :file, :csv

    def intrinio!
      Intrinio::API.new options
    end

    # Called when the arguments match one of the usage patterns. Will 
    # delegate action to other, more specialized methods.
    def handle(args)
      @path   = args['PATH']
      @params = translate_params args['PARAMS']
      @file   = args['FILE']
      @csv    = args['--csv']

      if intrinio_auth.empty?
        raise Intrinio::MissingAuth, "Missing Authentication\nPlease set INTRINIO_AUTH=username:password"
      end
      
      return get    if args['get']
      return pretty if args['pretty']
      return see    if args['see']
      return url    if args['url']
      return save   if args['save']
    end

    def get
      if csv
        puts intrinio.get_csv path, params
      else
        puts intrinio.get! path, params
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
      response = intrinio.get path, params
      puts JSON.pretty_generate response
    end

    def see
      ap intrinio.get path, params
    end

    def url
      intrinio.debug = true
      puts intrinio.get path, params
      intrinio.debug = false
    end

    # Convert a params array like [key:value, key:value] to a hash like
    # {key: value, key: value}
    def translate_params(pairs)
      return nil if pairs.empty?
      result = {}
      pairs.each do |pair|
        key, value = pair.split ':'
        result[key] = value
      end
      result
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
