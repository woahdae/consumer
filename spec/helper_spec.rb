require File.dirname(__FILE__) + "/spec_helper"

describe Consumer::Helper do
  describe "tidy" do
    it "formats a basic newline-less glob of xml into something pretty" do
      @dirty = "<hello><woot>hoo yeah nelly</woot></hello>"
      @clean = <<-EOF
<hello>
  <woot>hoo yeah nelly</woot>
</hello>
EOF
    end
    
    it "reformats nil nodes into <element/>" do
      @dirty = "<hello><nil></nil><notnil>text</notnil></hello>"
      @clean = <<-EOF
<hello>
  <nil/>
  <notnil>text</notnil>
</hello>
EOF
    end
    
    it "reformats more complex globs" do
      @dirty = "<?xml version=\"1.0\"?><RatingServiceSelectionResponse><Response><TransactionReference><CustomerContext>RatingandService</CustomerContext><XpciVersion>1.0001</XpciVersion></TransactionReference><ResponseStatusCode>1</ResponseStatusCode><ResponseStatusDescription>Success</ResponseStatusDescription></Response><RatedShipment><Service><Code>03</Code></Service></RatedShipment></RatingServiceSelectionResponse>"
      @clean = <<-EOF
<?xml version="1.0"?>
<RatingServiceSelectionResponse>
  <Response>
    <TransactionReference>
      <CustomerContext>RatingandService</CustomerContext>
      <XpciVersion>1.0001</XpciVersion>
    </TransactionReference>
    <ResponseStatusCode>1</ResponseStatusCode>
    <ResponseStatusDescription>Success</ResponseStatusDescription>
  </Response>
  <RatedShipment>
    <Service>
      <Code>03</Code>
    </Service>
  </RatedShipment>
</RatingServiceSelectionResponse>
EOF
    end
    
    after(:each) do
      res = Consumer::Helper.tidy(@dirty) 
      puts res if res != @clean
      res.should == @clean
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
      Consumer::Helper.compact_xml(@dirty).should == @clean
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
      Consumer::Helper.hash_from_yaml(file, @namespace).should == {"hello" => "world"}
    end
  end
end