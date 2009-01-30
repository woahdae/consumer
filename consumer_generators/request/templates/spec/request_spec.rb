require File.dirname(__FILE__) + "/spec_helper"

describe <%= "#{appname.camelcase}::#{request_class}" %> do

  it "creates xml" do
    <%= request_class.underscore %> = <%= request_class %>.new({
      # :attribute => value
    })
    xml = <%= request_class.underscore %>.to_xml_etc
    xml.should =~ /\<\?xml/
  end
  
  # run "DO_IT_LIVE=true spec spec" to contact the api
  if ENV['DO_IT_LIVE']
    
    it "contacts the live api and returns <%= response_class %> instance(s)" do
      $DEBUG = true # spit out xml for the request & response
      
      <%= response_class.underscore %> = <%= request_class %>.new({
        # :attribute => "value"
      }).do
      <%= response_class.underscore %>.should_not be_blank
    end

  end

end