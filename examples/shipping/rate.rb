require File.dirname(__FILE__) + "/environment"

class Rate
  include Consumer::Mapping
  attr_accessor :service, :code, :price, :carrier
  
  # UPS
  map(:all, "//RatingServiceSelectionResponse/RatedShipment", {
    :price => "TotalCharges/MonetaryValue",
    # :name => "Service",
    :code => "Service/Code"
  }) {|instance| instance.carrier = "UPS" }
  
end

