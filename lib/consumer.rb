$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'libxml'
require 'builder'
require 'active_support/core_ext/string/inflections'

class String
  # I just want singularize and constantize from ActiveSupport,
  # but I don't need the rest of AS
  include ActiveSupport::CoreExtensions::String::Inflections
end

module Consumer
  VERSION = '0.8.0'
end

require 'consumer/mapping'
require 'consumer/request'
require 'consumer/helper'