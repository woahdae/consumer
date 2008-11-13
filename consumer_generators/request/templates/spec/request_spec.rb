require File.dirname(__FILE__) + "/spec_helper"

describe <%= request_class %> do
  
  it "should get rates with a canned response" do
    file = "spec/xml/<%= response_xml %>"
    xml = File.read("#{file}")
    raise "need to put example response in #{file}" if xml.blank?

    response = mock("HTTPResponse", :body => xml)
    http = mock("http", :post => response)
    http.stub!(:use_ssl=)
    http.stub!(:verify_mode=)
    Net::HTTP.should_receive(:new).and_return(http)
    
    do_request
  end

  # run "DO_IT_LIVE=true spec spec" to contact the api
  if ENV['DO_IT_LIVE']
    it "should get live rates" do
      $DEBUG = true # spit out xml for the request & response
      do_request
    end
  end
  
  def do_request
    args = {
      # :attribute => "value"
    }
    raise "need to populate args for request" if args.empty?
    
    result = <%= request_class %>.new(args).do

    result.should_not be_blank
  end

end