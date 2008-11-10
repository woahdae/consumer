#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/environment'

ActiveRecord::Schema.define do
  create_table "books", :force => true do |t|
    t.string  :title
    t.text    :description
    t.string  :isbn
  end
  
  create_table "contributors", :force => true do |t|
    t.string :name
    t.string :role
  end
  
  create_table "books_contributors", :force => true do |t|
    t.integer :book_id
    t.integer :contributor_id
  end
end