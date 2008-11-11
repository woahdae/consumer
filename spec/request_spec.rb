require File.dirname(__FILE__) + "/spec_helper"

class MockRequest < XmlConsumer::Request
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
      object = request.do
      object.hello.should == "Woody"
    end
  end
  
  describe "hash_from_yaml" do
    it "should load a yaml file and return a hash" do
      yaml = <<-EOF
      hello: world
      EOF
      file = "some/file.yaml"
      File.should_receive(:exists?).and_return(true)
      File.should_receive(:read).with("some/file.yaml").and_return(yaml)
      MockRequest.new.send(:hash_from_yaml, file).should == {"hello" => "world"}
    end
    
    it "should return a subsection of the yaml if given a namespace" do
      yaml = <<-EOF
      greetings:
        hello: world
      other:
        not: relevant
      EOF
      file = "some/file.yaml"
      File.should_receive(:exists?).and_return(true)
      File.should_receive(:read).with("some/file.yaml").and_return(yaml)
      MockRequest.new.send(:hash_from_yaml, file, "greetings").should == {"hello" => "world"}
    end
  end
  
  describe "tidy" do
    it "formats a newline-less glob of xml into something pretty" do
      request = XmlConsumer::Request.new
      dirty = "<hello><woot>hoo yeah nelly</woot><empty></empty></hello>"
      clean = "<hello>\n  <woot>\n    hoo yeah nelly\n  </woot>\n  <empty/>\n</hello>\n"
      request.send(:tidy, dirty).should == clean
    end
  end
  
  describe "compact_xml" do
    before(:each) do
      @request = XmlConsumer::Request.new
    end
    
    it "removes empty xml nodes" do
      @dirty = "<hello><woot></woot><moogle>blah</moogle></hello>"
      @clean = "<hello><moogle>blah</moogle></hello>"
    end
    
    it "removes nodes with only empty nodes inside" do
      @dirty = "<hello><woot></woot><moogle><still_empty></still_empty></moogle></hello>"
      @clean = ""
    end
    
    it "remove empty nodes containing whitespace characters" do
      @dirty = "<hello>  \r \t\n</hello>"
      @clean = ""
    end
    
    after(:each) do
      @request.send(:compact_xml, @dirty).should == @clean
    end
  end
end