require 'rubygems'
require 'consumer'

Dir.glob(File.join(File.dirname(__FILE__), '<%= name %>/**/*.rb')).each {|f| require f}
