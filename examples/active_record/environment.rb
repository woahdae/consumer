require 'rubygems'
require 'active_record'
require 'sqlite3'


require File.dirname(__FILE__) + '/../../lib/xml_consumer.rb'

$:.unshift(File.dirname(__FILE__))
require 'models/contributor'
require 'models/book'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile  => 'database.sqlite'
)
