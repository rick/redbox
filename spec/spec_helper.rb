require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

# this is my favorite way to require, ever
begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

begin
  require 'mocha'
rescue LoadError
  require 'rubygems'
  gem 'rr'
  require 'rr'
end

Spec::Runner.configure do |config|
  config.mock_with :rr
end

