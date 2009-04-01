require File.dirname(__FILE__) + "/spec_helper"

describe Consumer::Helper do
  describe "tidy" do
    it "formats a basic newline-less glob of xml into something pretty" do
      @dirty = "<hello><woot>hoo yeah nelly</woot></hello>"
      @clean = <<-EOS
<hello>
  <woot>hoo yeah nelly</woot>
</hello>
EOS
    end
    
    it "reformats nil nodes into <element/>" do
      @dirty = "<hello><nil></nil><notnil>text</notnil></hello>"
      @clean = <<-EOS
<hello>
  <nil/>
  <notnil>text</notnil>
</hello>
EOS
    end
    
    it "reformats more complex globs" do
      @dirty = "<?xml version=\"1.0\"?><RatingServiceSelectionResponse><Response><TransactionReference><CustomerContext>RatingandService</CustomerContext><XpciVersion>1.0001</XpciVersion></TransactionReference><ResponseStatusCode>1</ResponseStatusCode><ResponseStatusDescription>Success</ResponseStatusDescription></Response><RatedShipment><Service><Code>03</Code></Service></RatedShipment></RatingServiceSelectionResponse>"
      @clean = <<-EOS
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
EOS
    end
    
    it "reformats xml with newlines" do
      @dirty = <<-EOS
<?xml version="1.0"?>
<Error><Number>-2147219490</Number><Source>Rate_Respond;SOLServerRatesTest.RateV2_Respond</Source><Description>Invalid value for origin ZIP Code.</Description><HelpFile></HelpFile><HelpContext>1000440</HelpContext></Error>
EOS
      @clean = <<-EOS
<?xml version="1.0"?>
<Error>
  <Number>-2147219490</Number>
  <Source>Rate_Respond;SOLServerRatesTest.RateV2_Respond</Source>
  <Description>Invalid value for origin ZIP Code.</Description>
  <HelpFile/>
  <HelpContext>1000440</HelpContext>
</Error>

EOS
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
    
    it "removes empty nodes containing whitespace characters" do
      @dirty = "<hello>  \r \t\n</hello>"
      @clean = ""
    end
    
    it "works with namespaces" do
      @dirty = "<ns:hello>\n</ns:hello>"
      @clean = ""
    end
    
    it "should not clean nodes with attributes" do
      @dirty = "<hello attr='blah'>\n</hello>"
      @clean = "<hello attr='blah'>\n</hello>"
    end
    
    it "works with empty nodes of the form <node />" do
      @dirty = "<hello />"
      @clean = ""
    end

    after(:each) do
      Consumer::Helper.compact_xml(@dirty).should == @clean
    end
  end
  
  describe "hash_from_yaml" do
    it "should load a yaml file and return a hash" do
      @yaml = <<-EOS
      hello: world
      EOS
      perform
    end
    
    it "should return a subsection of the yaml if given a namespace" do
      @yaml = <<-EOS
      greetings:
        hello: world
      other:
        not: relevant
      EOS
      @namespace = "greetings"
      perform
    end
    
    it "should return {} if no hash" do
      @yaml = ""
      @namespace = "greetings"
      perform({})
    end
    
    it "should have 'all' as a global namespace" do
      @yaml = <<-EOS
      all:
        answer: 42
      greetings:
        hello: world
      other:
        not: relevant
      EOS
      @namespace = "greetings"
      perform({"hello" => "world", "answer" => 42})
    end

    def perform(result = {"hello" => "world"})
      File.should_receive(:read).with("config/file.yml").and_return(@yaml)
      Consumer::Helper.hash_from_yaml("config", "file.yml", @namespace).should == result
    end
    
  end
end