class Book < ActiveRecord::Base
  include XmlConsumer::Mapping
  has_and_belongs_to_many :contributors

  @habtm_registry = {
    :isbn => "attribute::isbn",
    :title => "title",
    :description => "description"
  }
  
  map(:first, "//BookResponse/book", @habtm_registry, :include => :contributors)
  map(:all, "//ContributorResponse/contributor/books/book", @habtm_registry)
end