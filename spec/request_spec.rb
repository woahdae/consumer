require File.dirname(__FILE__) + "/spec_helper"

class MockRequest < XmlConsumer::Request
  required :hello
  
  def to_xml
    b.instruct!
    b.RequestBody {
      b.Hello @hello
    }
  end
  
  def url
    "http://www.example.com/api"
  end
end

class Mock
  include XmlConsumer::Mapping
  attr_accessor :hello
  map(:first, "//SillyXml", {:hello => "Hello"})
end

describe XmlConsumer::Request do
  describe "initialize" do
    it "should load defaults, with passed-in values taking priority" do
      request = MockRequest.allocate # creates an object w/o calling initialize
      request.should_receive(:hash_from_yaml).and_return({:hello => "default value", :another => "value"})
      request.should_receive(:initialize_attrs).with({:hello => "passed in value", :another => "value"})
      request.send(:initialize, :hello => "passed in value")
    end
  end
  
  describe "do" do
    it "sends a request to the defined url and returns instantiated objects" do
      request = MockRequest.new(:hello => "Woody")
    
      # stop communication with www.example.com
      request_xml = <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<RequestBody>
  <Hello>Woody</Hello>
</RequestBody>
      EOF
      response_xml = <<-EOF
      <SillyXml>
        <Hello>Woody</Hello>
      </SillyXml>
      EOF
      http = mock("aaa", :use_ssl= => "", :verify_mode= => "")
      Net::HTTP.stub!(:new).and_return(http)
    
      http.should_receive(:post).
        with("/api", request_xml).
        and_return(mock("response", :body => response_xml))
      mock = request.do
      mock.hello.should == "Woody"
    end
  end
  
  describe "tidy" do
    it "can tidy xml" do
      request = XmlConsumer::Request.new
      dirty = "<hello><woot>hoo yeah nelly</woot><empty></empty></hello>"
      clean = "<hello>\n  <woot>\n    hoo yeah nelly\n  </woot>\n  <empty/>\n</hello>\n"
      request.send(:tidy, dirty).should == clean
    end
  end
end