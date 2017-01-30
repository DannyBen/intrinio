require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

include Intrinio

def fixture(filename, data=nil)
  if data
    File.write "spec/fixtures/#{filename}", data
  else
    File.read "spec/fixtures/#{filename}"
  end
end