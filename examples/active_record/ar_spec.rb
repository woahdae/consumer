require 'spec'
require 'environment'

# Very broad tests to see Consumer working with Active Record

describe "ROXML in ActiveRecord" do
  before(:all) do
    @book_xml = File.read("xml/book.xml")
    @book_with_contributors_xml = File.read("xml/book_with_contributors.xml")
    @contributor_with_books_xml = File.read("xml/contributor_with_books.xml")
    @contributor_xml = File.read("xml/contributor.xml")
  end

  it "creates a valid AR object from xml" do
    book = Book.from_xml(@book_xml)
    book.isbn.should == "0974514055"
    book.title.should == "Programming Ruby - 2nd Edition"
    book.description.should == "Second edition of the great book out there"
    book.save.should be_true
  end

  describe "habtm for books-contributors" do
    it "works from the book side of the relationship" do
      book = Book.from_xml(@book_with_contributors_xml)
      book.contributors.size.should == 3
    end
    
    it "works from the contributor side of the relationship" do
      contributor = Contributor.from_xml(@contributor_with_books_xml)
      contributor.books.size.should == 3
    end
  end
end