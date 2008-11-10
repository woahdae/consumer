class Contributor < ActiveRecord::Base
  include XmlConsumer::Mapping
  has_and_belongs_to_many :books

  @habtm_registry = {
    :role => "attribute::role",
    :name => "name"
  }
  
  map(:first, "//ContributorResponse/contributor", @habtm_registry, :include => :books)
  map(:all, "//BookResponse/book/contributors/contributor", @habtm_registry)
end