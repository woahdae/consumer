# === Vendor API Docs
# http://www.example.com/handy_docs
class <%= request_class %> < Consumer::Request
  response_class "<%= response_class %>"
  error_paths({
    :root    => "//Error",
    :code    => "//ErrorCode",
    :message => "//ErrorDescription"
  })
  yaml_defaults "config.yml", "<%= request_base.underscore %>"
  required(
    # :required_attrs_array
  )
  defaults({
    # :sensible_default => "Value"
  })
  
  def url
    return "www.example.com/testing" if $TESTING
    
    "www.example.com"
  end

  def to_xml
    b.instruct!
    
    # Consumer::Request comes with a ready to use Builder instance.
    # docs at http://builder.rubyforge.org/classes/Builder/XmlMarkup.html
    # example:
    b.<%= request_class %> {
      b.Hello "World"
    }
  end
end