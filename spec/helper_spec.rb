require File.dirname(__FILE__) + "/spec_helper"

describe XmlConsumer::Helper do
  describe "tidy" do
    it "formats a newline-less glob of xml into something pretty" do
      dirty = "<hello><woot>hoo yeah nelly</woot><empty></empty></hello>"
      clean = "<hello>\n  <woot>\n    hoo yeah nelly\n  </woot>\n  <empty/>\n</hello>\n"
      XmlConsumer::Helper.tidy(dirty).should == clean
    end
  end
  
  describe "compact_xml" do
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
      XmlConsumer::Helper.compact_xml(@dirty).should == @clean
    end
  end
  
  describe "hash_from_yaml" do
    it "should load a yaml file and return a hash" do
      @yaml = <<-EOF
      hello: world
      EOF
    end
    
    it "should return a subsection of the yaml if given a namespace" do
      @yaml = <<-EOF
      greetings:
        hello: world
      other:
        not: relevant
      EOF
      @namespace = "greetings"
    end
    
    after(:each) do
      file = "some/file.yaml"
      File.should_receive(:exists?).and_return(true)
      File.should_receive(:read).with("some/file.yaml").and_return(@yaml)
      XmlConsumer::Helper.hash_from_yaml(file, @namespace).should == {"hello" => "world"}
    end
  end
end