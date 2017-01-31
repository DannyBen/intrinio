require 'spec_helper'

describe API do
  before :all do
    ENV['INTRINIO_AUTH'] or raise "Please set INTRINIO_AUTH=user:pass before running tests"
  end

  let(:intrinio) { API.new auth: ENV['INTRINIO_AUTH'], use_cache: true }

  describe '#new' do
    it "initializes with credentials" do
      intrinio = API.new username: 'me', password: 'secret'
      expect(intrinio.opts[:username]).to eq 'me'
      expect(intrinio.opts[:password]).to eq 'secret'
    end

    it "initializes with compact credentials" do
      intrinio = API.new auth: 'me:secret'
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

  describe '#get_csv' do
    context "with a valid request" do
      it "returns a csv string" do
        result = intrinio.get_csv :historical_data, identifier: 'AAPL', 
          item: 'adj_close_price', start_date: '2016-01-01', 
          end_date: '2016-01-31', sort_order: 'asc'
          
        expect(result).to eq fixture('aapl.csv')
      end
    end

    context "with a non hash response" do
      it "raises an error" do
        expect{intrinio.get_csv :bogus_endpoint}.to raise_error(BadResponse)
      end
    end

    context "with a response that has no data attribute" do
      it "raises an error" do
        expect{
          intrinio.get_csv :companies, identifier:'AAPL'
        }.to raise_error(IncompatibleResponse)
      end
    end
  end

  describe '#save_csv' do
    let(:filename) { 'tmp.csv' }

    it "saves output to a file" do
      File.delete filename if File.exist? filename
      expect(File).not_to exist(filename)

      intrinio.save_csv filename, :historical_data, identifier: 'AAPL',
        item: 'adj_close_price', start_date: '2016-01-01', 
        end_date: '2016-01-31', sort_order: 'asc'
      
      expect(File).to exist(filename)
      expect(File.read filename).to eq fixture('aapl.csv')
      
      File.delete filename
    end
  end
end
