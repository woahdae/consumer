require File.dirname(__FILE__) + "/spec_helper"

class MockObject
  include Consumer::Mapping
  attr_accessor :price, :integers
end

describe Consumer::Mapping do
  before(:each) do
    # since maps are defined on the class and we want to test variations
    # on the same map, let's clear it before each spec
    MockObject.instance_variable_set("@maps", [])
  end
  
  describe "find_nodes_and_map" do
    it "finds the correct map for the xml" do
      xml = File.read("spec/xml/rate_response.xml")
      map = MockObject.map(:first, "//CrazyCarrierRateResponse/ShipService",{})
      not_the_map = MockObject.map(:first, "//NotTheMapping/ShipService", {})
      MockObject.send(:find_nodes_and_map, xml)[1].should == map
    end
  end
  
  it "creates an attribute hash given a node and a map registry" do
    xml = File.read("spec/xml/rate_response.xml")
    node = LibXML::XML::Parser.string(xml).parse.find("//ShipService").first
    registry = {:price => "Cost"}
    attrs = MockObject.send(:attrs_from_node_and_registry, node, registry)
    attrs.should == {:price => "5.00"}
  end
  
  it "creates a new instance from an attribute hash" do
    attrs = {:price => "5.00"}
    object = MockObject.from_hash(attrs)
    object.price.should == "5.00"
  end
  
  it "creates instances from xml via the appropriate map" do
    xml = <<-EOF
    <CarrierResponse>
      <ShipService>
        <Cost>5.00</Cost>
      </ShipService>
    </CarrierResponse>
    EOF
    MockObject.map(:first, "//CarrierResponse/ShipService",{:price => "Cost"})
    object = MockObject.from_xml_via_map(xml)
    object.price.should == "5.00"
  end
  
  it "raises an error if you try to define the same map root twice" do
    MockObject.map(:first, "//CarrierResponse",{:something => "woot"})

    lambda {
      MockObject.map(:first, "//CarrierResponse",{:another => "AAA"})
    }.should raise_error
  end
  
  it "calls map blocks" do
    MockObject.map(:first, "//empty", {}) {|instance| instance.price = "5"}
    object = MockObject.from_xml_via_map("<empty></empty>")
    object.price.should == "5"
  end

  it "calls map blocks with node also" do
    MockObject.map(:first, "//empty", {}) {|instance, node| instance.price = node.find_first("//empty").content}
    object = MockObject.from_xml_via_map("<empty>5</empty>")
    object.price.should == "5"
  end
  
  describe "association_from_xml" do
    it "creates an association from xml" do
      object = MockObject.new
      Integer.should_receive(:from_xml).with("some xml").and_return([1,2])
      object.should_receive("integers=").with([1,2])
      object.association_from_xml("some xml", :integers)
    end
  end
  
  describe "registry" do
    it "accepts attributs as values" do
      xml = <<-EOF
      <CarrierResponse>
        <ShipService cost="5.00">
          Irrelevant value in content
        </ShipService>
      </CarrierResponse>
      EOF
      MockObject.map(:first, "//CarrierResponse/ShipService",{:price => "attribute::cost"})
      object = MockObject.from_xml_via_map(xml)
      object.price.should == "5.00"
    end
  end
end