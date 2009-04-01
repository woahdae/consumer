require File.dirname(__FILE__) + "/spec_helper"

class MockRequest < Consumer::Request
  required :hello
  url      "http://www.example.com/api"
  
  def to_xml
    b.instruct!
    b.RequestBody {
      b.Hello @hello
    }
  end
end

class Mock
  include Consumer::Mapping
  attr_accessor :hello
  map(:first, "//SillyXml", {:hello => "Hello"})
end

describe Consumer::Request do
  describe "initialize" do
    it "should load defaults, with passed-in values taking priority" do
      request = MockRequest.allocate # creates an object w/o calling initialize
      Consumer::Helper.should_receive(:hash_from_yaml).
        and_return({:hello => "default value", :another => "value"})
      request.should_receive(:initialize_attrs).
        with({:hello => "passed in value", :another => "value"}).twice
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
      http = mock("Http", :use_ssl= => "", :verify_mode= => "")
      Net::HTTP.stub!(:new).and_return(http)
    
      http.should_receive(:request).
        and_return(mock("response", :body => response_xml, :response => mock("aoeu", :code => "200")))
      object = request.do
      object.hello.should == "Woody"
    end
  end
  
  describe "check_request_error" do
    it "should raise a RequestError if the response xml contains an error" do
      request = MockRequest.new
      request.stub!(:error_paths).and_return({
        :root    => "//Error",
        :code    => "//ErrorCode",
        :message => "//ErrorDescription"
      })
      resp_xml = File.read("spec/xml/rate_response_error.xml")
      
      lambda {request.send(:check_request_error, resp_xml) }.
        should raise_error(Consumer::Request::RequestError)
    end
  end
  
end