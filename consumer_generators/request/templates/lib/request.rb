# === Vendor API Docs
# http://www.example.com/handy_docs
class <%= request_class %> < Consumer::Request
  response_class "<%= response_class %>"
  yaml_defaults "<%= appname %>.yml", "<%= request_base.underscore %>"
  
  # If root is found in a response, code + message will be raised
  error_paths({
    :root    => "//Error",
    :code    => "//ErrorCode",
    :message => "//ErrorDescription"
  })
  
  # Instance variables that must be set before xml sendoff
  def required
    return [
      # :required_attrs_array
    ]
  end
  
  # Lowest priority; overwritten by YAML, then params
  def defaults
    return {
      # :sensible_default => "Value"
    }
  end
  
  def url
    return "www.example.com/testing" if $TESTING
    
    "www.example.com"
  end
  
  # All this has to do is return xml, and we have a Builder instance to help.
  # Also, defaults, YAML, and the params are accessed via instance variables.
  def to_xml
    b.instruct!
    
    # docs at http://builder.rubyforge.org/classes/Builder/XmlMarkup.html
    # example:
    b.<%= request_class %> {
      b.Hello "World"
    }
  end
end