require File.dirname(__FILE__) + "/environment"

class UPSRateRequest < XmlConsumer::Request
  response_class "Rate"
  yaml_defaults  "shipping.yml", "ups"
  required       :access_license_number
  error_paths({
    :root    => "//Error",
    :code    => "//ErrorCode",
    :message => "//ErrorDescription"
  })
  defaluts({
    :customer_type  => "wholesale",
    :pickup_type    => "daily_pickup",
    :service_type   => "ground",
    :package_type   => "your_packaging",
    :weight_units   => 'LBS', # or KGS
    :measure_units  => 'IN',
    :measure_length => 0,
    :measure_width  => 0,
    :measure_height => 0,
    :currency_code  => "US"
  })
  
  def url
    return "https://wwwcie.ups.com/ups.app/xml/Rate" if $TESTING
    
    "https://www.ups.com/ups.app/xml/Rate"
  end

  API_VERSION = "1.0001"
  
  PackageTypes = {
    "ups_envelope" => "01",
    "your_packaging" => "02",
    "ups_tube" => "03",
    "ups_pak" => "04",
    "ups_box" => "21",
    "fedex_25_kg_box" => "24",
    "fedex_10_kg_box" => "25"
  }

  ServiceTypes = {
    "next_day" => "01",
    "2day" => "02",
    "ground" => "03",
    "worldwide_express" => "07",
    "worldwide_expedited" => "08",
    "standard" => "11",
    "3day" => "12",
    "next_day_saver" => "13",
    "next_day_early" => "14",
    "worldwide_express_plus" => "54",
    "2day_early" => "59"
  }
  
  PaymentTypes = {
    'prepaid' => 'Prepaid',
    'consignee' => 'Consignee',
    'bill_third_party' => 'BillThirdParty',
    'freight_collect' => 'FreightCollect'
  }

  # UPS-Specific types

  PickupTypes = {
    'daily_pickup' => '01',
    'customer_counter' => '03',
    'one_time_pickup' => '06',
    'on_call' => '07',
    'suggested_retail_rates' => '11',
    'letter_center' => '19',
    'air_service_center' => '20'
  }

  CustomerTypes = {
    'wholesale' => '01',
    'ocassional' => '02',
    'retail' => '04'
  }
  
  def to_xml
    b.instruct!

    b.AccessRequest {
      b.AccessLicenseNumber @access_license_number
      b.UserId @user_id
      b.Password @password
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
        b.Code CustomerTypes[@customer_type]
      }
      b.PickupType {
        b.Code PickupTypes[@pickup_type]
      }
      b.Shipment {
        b.Shipper {
          b.Address {
            b.PostalCode @sender_zip
            b.CountryCode @sender_country
            b.City @sender_city 
            b.StateProvinceCode sender_state
          }
        }
        b.ShipTo {
          b.Address {
            b.PostalCode @zip
            b.CountryCode @country
            b.City @city
            b.StateProvinceCode state 
          }
        }
        b.Service {
          b.Code ServiceTypes[@service_type]
        }
        b.Package {
          b.PackagingType {
            b.Code PackageTypes[@packaging_type]
            b.Description 'Package'
          }
          b.Description 'Rate Shopping'
          b.PackageWeight {
            b.Weight @weight
            b.UnitOfMeasurement {
              b.Code @weight_units
            }
          }
          b.Dimensions {
            b.UnitOfMeasurement {
              b.Code @measure_units
            }
            b.Length @measure_length
            b.Width @measure_width
            b.Height @measure_height
          }
          b.PackageServiceOptions {
            b.InsuredValue {
              b.CurrencyCode @currency_code
              b.MonetaryValue @insured_value
            }
          }
        }
      }
    }
        
  end
end