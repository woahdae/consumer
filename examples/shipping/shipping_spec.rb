require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + "/environment"

$TESTING = true
describe "Shipping" do
  if ENV['DO_IT_LIVE'] # http://www.youtube.com/watch?v=2tJjNVVwRCY&feature=related
    describe "UPS" do
      it "should work" do
        rates = UPSRateRequest.new.do
        rates.should_not be_nil
      end
    end
  end
end