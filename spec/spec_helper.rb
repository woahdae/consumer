begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$TESTING = true

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'consumer'
