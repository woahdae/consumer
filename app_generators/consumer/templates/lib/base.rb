require 'rubygems'
require 'consumer'

module <%= name.camelcase %>;end

Dir.glob(File.join(File.dirname(__FILE__), '<%= name %>/**/*.rb')).each {|f| require f}
