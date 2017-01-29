require 'spec_helper'

describe CommandLine do
  let(:cli) { Intrinio::CommandLine.instance }

  before :all do
    ENV['INTRINIO_AUTH'] or raise "Please set INTRINIO_AUTH=user:pass before running tests"
  end

  describe '#initialize' do
    let(:cli) { Intrinio::CommandLine.clone.instance }

    context "without environment variables" do
      before do
        ENV['INTRINIO_CACHE_DIR'] = nil
        ENV['INTRINIO_CACHE_LIFE'] = nil
      end

      it "has cache disabled" do
        expect(cli.intrinio.cache).not_to be_enabled
      end
    end

    context "with CACHE_DIR" do
      it "enables cache" do
        ENV['INTRINIO_CACHE_DIR'] = 'hello'
        expect(cli.intrinio.cache).to be_enabled
        expect(cli.intrinio.cache.dir).to eq 'hello'
        ENV.delete 'INTRINIO_CACHE_DIR'
      end
    end

    context "with CACHE_LIFE" do
      it "enables cache" do
        ENV['INTRINIO_CACHE_LIFE'] = '123'
        expect(cli.intrinio.cache).to be_enabled
        expect(cli.intrinio.cache.life).to eq 123
        ENV.delete 'INTRINIO_CACHE_LIFE'
      end
    end
  end

  describe '#execute' do
    before do
      ENV['INTRINIO_CACHE_DIR'] = 'cache'
    end

    context "without arguments" do
      it "shows usage patterns" do
        expect {cli.execute}.to output(/Usage:/).to_stdout
      end
    end

    context "with url command" do
      let(:command) { %w[url doesnt really:matter] }

      it "returns a url" do
        expected = /api\.intrinio\.com\/doesnt\?really=matter/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with get command" do
      let(:command) { %w[get indices page_size:1] }

      it "prints json output" do
        expected = /\{"data":.*\}/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with pretty command" do
      let(:command) { %w[pretty indices page_size:1] }

      it "prints a prettified json output" do
        expected = /\{\n\s+"data": \[\n.*\}/m
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with see command" do
      let(:command) { %w[see indices page_size:1] }

      it "awesome-prints output" do
        expected = /:data.*=>.*\[/
        expect {cli.execute command}.to output(expected).to_stdout
      end
    end

    context "with save command" do
      let(:command) { %W[save tmp.json indices page_size:1] }

      it "saves a file", type: :premium do
        File.unlink 'tmp.json' if File.exist? 'tmp.json'
        expect(File).not_to exist 'tmp.json'
        expected = "Saved tmp.json\n"

        expect {cli.execute command}.to output(expected).to_stdout
        expect(File).to exist 'tmp.json'
        expect(File.size 'tmp.json').to be > 200

        File.unlink 'tmp.json'
      end
    end

    context "with an invalid path" do
      let(:command) { %W[get not_here] }
      
      it "fails with honor" do
        expect {cli.execute command}.to output(/404 Not Found/).to_stdout
      end
    end
  end

end