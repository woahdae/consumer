require File.dirname(__FILE__) + "/spec_helper"

describe <%= "#{appname.camelcase}::#{response_class}" %> do
  it "should make an instance of itself via from_xml" do
    file = "spec/xml/<%= response_xml %>"
    xml = File.read("#{file}")
    
    <%= response_class %>.from_xml(xml).should_not be_blank
  end
end