class <%= "#{appname.camelcase}::#{response_class}" %>
  include Consumer::Mapping
  attr_accessor :attribute
  
  # This is fairly dense; see documentation for full explanation
  # map(:all or :first, "root xpath", registry, opts = {}, &postprocessing)
  map(:all, "//FullyQualified/Xpath/ToRoot", {
      :attribute => "RelativeOrFQxPathToValue",
    },
    :include => [:association1, :association2]
  ) {|<%= response_class.underscore %>| <%= response_class.underscore%>.attribute.strip! }
end
