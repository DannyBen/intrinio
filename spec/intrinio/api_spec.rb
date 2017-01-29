require 'spec_helper'

describe API do
  describe '#new' do
    it "initializes with credentials" do
      intrinio = API.new username: 'me', password: 'secret'
      expect(intrinio.opts[:username]).to eq 'me'
      expect(intrinio.opts[:password]).to eq 'secret'
    end

    it "sets the credentials in the webcache" do
      intrinio = API.new username: 'me', password: 'secret'
      expect(intrinio.cache.options[:http_basic_authentication]).to eq ['me', 'secret']
    end

    it "starts with cache disabled" do
      intrinio = API.new
      expect(intrinio.cache).not_to be_enabled
    end

    it "initializes with options" do
      intrinio = API.new username: 'me', password: 'secret',
        base_url: 'http://new.intrinio.com/v99',
        use_cache: true,
        cache_dir: 'custom',
        cache_life: 1337

      expect(intrinio.base_url).to eq 'http://new.intrinio.com/v99'
      expect(intrinio.cache.dir).to eq 'custom'
      expect(intrinio.cache.life).to eq 1337
      expect(intrinio.cache).to be_enabled
    end

  end
end
