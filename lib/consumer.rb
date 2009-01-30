$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'libxml'
require 'builder'

# I just want singularize and constantize from ActiveSupport,
# but I don't need the rest of AS
module ActiveSupport
  module CoreExtensions
    module String
      module Inflections
      end
    end
  end
end
require 'active_support/core_ext/string/inflections'
class String
  include ActiveSupport::CoreExtensions::String::Inflections
end

module Consumer
  VERSION = '0.8.1'
end

require 'consumer/mapping'
require 'consumer/request'
require 'consumer/helper'