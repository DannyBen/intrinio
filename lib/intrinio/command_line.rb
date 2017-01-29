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
      rescue Docopt::Exit => e
        puts e.message
      end
    end

    def intrinio
      @intrinio ||= intrinio!
    end

    private

    def intrinio!
      Intrinio::API.new options
    end

    # Called when the arguments match one of the usage patterns. Will 
    # delegate action to other, more specialized methods.
    def handle(args)
      path   = args['PATH']
      params = args['PARAMS']
      file   = args['FILE']
      
      return get(path, params)        if args['get']
      return pretty(path, params)     if args['pretty']
      return see(path, params)        if args['see']
      return url(path, params)        if args['url']
      return save(file, path, params) if args['save']
    end

    def get(path, params)
      puts intrinio.get! path, translate_params(params)
    end

    def save(file, path, params)
      success = intrinio.save file, path, translate_params(params)
      puts success ? "Saved #{file}" : "Saving failed"
    end

    def pretty(path, params)
      intrinio.format = :json
      response = intrinio.get path, translate_params(params)
      puts JSON.pretty_generate response
    end

    def see(path, params)
      ap intrinio.get path, translate_params(params)
    end

    def url(path, params)
      intrinio.debug = true
      puts intrinio.get path, translate_params(params)
      intrinio.debug = false
    end

    # Convert a params array like [key:value, key:value] to a hash like
    # {key: value, key: value}
    def translate_params(params)
      return nil if params.empty?
      result = {}
      params.each do |param|
        key, value = param.split ':'
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
