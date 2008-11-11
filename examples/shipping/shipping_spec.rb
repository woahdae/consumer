require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + "/environment"

$TESTING = true
$DEBUG = true
describe "Shipping" do
  if ENV['DO_IT_LIVE'] # http://www.youtube.com/watch?v=2tJjNVVwRCY&feature=related
    describe "UPS" do
      it "should work" do
        rates = UPSRateRequest.new(
          :zip => "98125",
          :country => "US",
          :weight => "5.00",

          # optional
          # :city => "Seattle",
          # :state => "WA",
          :request_type => "Shop" # take out shop, and it'll return one ground rate
        ).do
        
        rates.should_not be_nil
        rates.size.should > 1 # comment unless request_type => 'Shop'
      end
    end
  end
end