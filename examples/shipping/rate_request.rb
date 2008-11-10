require File.dirname(__FILE__) + "/environment"

class RateRequest < XmlLand::Request
  
  API_VERSION = "1.0001"
  
  def url
    "https://wwwcie.ups.com/ups.app/xml/Rate"
  end
  
  def defaults_file
    "shipping.yml"
  end
  
  def error_paths
    {
      :root => "//Error",
      :code => "//ErrorCode",
      :message => "//ErrorDescription"
    }
  end
  
  def to_xml
    b.instruct!

    b.AccessRequest {
      b.AccessLicenseNumber "1B9F88F43F3B2148"
      b.UserId "magicarsenal*com"
      b.Password "bigmoney"
    }
    
    b.instruct!
    
    b.RatingServiceSelectionRequest {
      b.Request {
        b.TransactionReference {
          b.CustomerContext 'Rating and Service'
          b.XpciVersion API_VERSION
        }
        b.RequestAction 'Rate'
      }
      b.CustomerClassification {
        b.Code '01'
      }
      b.PickupType {
        b.Code '01'
      }
      b.Shipment {
        b.Shipper {
          b.Address {
            b.PostalCode "98105"
            b.CountryCode "US"
            b.City "Seattle"
            b.StateProvinceCode "WA"
          }
        }
        b.ShipTo {
          b.Address {
            b.PostalCode "98125"
            b.CountryCode "US"
            b.City "Seattle"
            b.StateProvinceCode "WA"
          }
        }
        b.Service { # The service code
          b.Code '03' # defaults to ground
        }
        b.Package { # Package Details         
          b.PackagingType {
            b.Code '02' # defaults to 'your packaging'
            b.Description 'Package'
          }
          b.Description 'Rate Shopping'
          b.PackageWeight {
            b.Weight 5
            b.UnitOfMeasurement {
              b.Code 'LBS' # or KGS
            }
          }
          b.Dimensions {
            b.UnitOfMeasurement {
              b.Code 'IN'
            }
            b.Length 0
            b.Width 0
            b.Height 0
          }
          b.PackageServiceOptions {
            b.InsuredValue {
              b.CurrencyCode 'US'
              b.MonetaryValue "0"
            }
          }
        }
      }
    }
    
  end
end