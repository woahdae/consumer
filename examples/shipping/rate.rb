require File.dirname(__FILE__) + "/environment"

class Rate
  include XmlLand::Mapping
  attr_accessor :name, :code, :price, :carrier
  
  map(:first, "//RatingServiceSelectionResponse/RatedShipment", {
    :price => "TotalCharges/MonetaryValue",
    # :name => "Service",
    :code => "Service/Code"
  }) {|instance| instance.carrier = "UPS" }
  
end

