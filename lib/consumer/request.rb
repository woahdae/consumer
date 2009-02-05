require 'net/http'
require 'net/https'
require 'yaml'

##
# === Class Attrubutes
# [+required+]       Defines attributes that must be present in any instance
#                    before calling +do+. Anything defined here but not set in
#                    the instance will raise a RequiredFieldError on calling +do+
#
#                    Defaluts to []
# [+response_class+] String for setting the class the request will use to parse
#                    the response.
#
#                    Defaults to [Something]Request, ex. for a
#                    RateRequest, this would default to "Rate".
#
#                    Note that the instance method with the same name returns a
#                    constant rather than the string set here.
# [+yaml_defaults+]  Consists of two parameters. In order:
#                    * The location (as a string) for a yaml file containing
#                      attribute defaults.
#                    * A namespace to grab the defaults out of.
#
#                      If your yaml looked like this:
#
#                      <pre>
#                      ups:
#                        user_id: Woody
#                      usps:
#                        user_id: John
#                      </pre>
#
#                      UPSRequest would want to use "ups" as the namespace value,
#                      where USPSRequest would want to use "usps"
#
#                      This is optional and has no default
# [+error_paths+]    If you define this in your subclasses to return a hash for
#                    error options (see "Options" below) they will raise
#                    informative RequestError errors with xml error info in the
#                    message.
#
#                    If this is left undefined and the remote server returns
#                    error xml rather than what you were expecting, you'll get
#                    generic xml parsing errors instead of something informative.
#
#                    Note: currently only handles one error.
#
#                    === Options
#
#                    All options are xpaths. All options except +:root+ are relative
#                    to the root (unless prefixed with "//")
#                    * +:root+    - Root element of the error(s)
#                    * +:code+    - Remote API's error code for this error
#                    * +:message+ - Informative part of the error
#
#                    === Example
#
#                    <pre>
#                    {
#                      :root => "//Error",
#                      :code => "ErrorCode",
#                      :message => "LongDescription"
#                    }
#                    </pre>
#
#                    Anything passed in to initialize will override these, though.
class Consumer::Request
  include Consumer
 
  class << self
    def url(url = nil)
      @url = url if url
      @url
    end
 
    def required(*args)
      @required = args if !args.empty?
      @required || []
    end
 
    def response_class(klass = nil)
      @response_class = klass if klass
      self.to_s =~ /(.+?)Request/
      @response_class || $1
    end
 
    def yaml_defaults(*args)
      @yaml_defaults = args if !args.empty?
      @yaml_defaults
    end
 
    def defaults(defaults = nil)
      @defaults = defaults if defaults
      @defaults || {}
    end
 
    def error_paths(options = nil)
      @error_paths = options if options
      @error_paths
    end
  end
 
  class RequestError < StandardError;end
  class RequiredFieldError < StandardError;end
 
  attr_reader :response_xml, :request_xml
 
  # First gets defaults from self.defaults, merges them with defaults from
  # +yaml_defaults+, merges all that with passed in attrs, and initializes all
  # those into instance variables for use in to_xml.
  def initialize(attrs = {})
    # it's really handy to have all the other attrs init'd when we call
    # self.defaults 'cuz we can use them to help define conditional defaults.
    root = self.config_root
    yaml = Helper.hash_from_yaml(root, *yaml_defaults)
    yaml, attrs = symbolize_keys(yaml, attrs)

    initialize_attrs(yaml.merge(attrs)) # load yaml, but attrs will overwrite dups

    # now self.defaults has access to above stuff
    class_defaults = self.defaults
    class_defaults = symbolize_keys(class_defaults).first

    # but we wanted defaults loaded first.
    all_defaults = class_defaults.merge(yaml)
    final_attrs = all_defaults.merge(attrs)
    initialize_attrs(final_attrs)
  end
 
  # Sends self.to_xml to self.url and returns new object(s) created via
  # [response_class].from_xml
  # === Prerequisites
  # * All attributes in self.required must exist; raises RequiredFieldError
  #   otherwise
  # * self.to_xml must be defined; RuntimeError otherwise
  # * self.url must be set; RuntimeError otherwise
  # * response_class.from_xml must be defined; RuntimeError otherwise
  # === Returns
  # Whatever response_class.from_xml(@response_xml) returns, which should be
  # an object or array of objects (an array of objects if response_class is
  # using Consumer::Mapping)
  def do
    return if defined?(self.abort?) && self.abort?
    raise "to_xml not defined for #{self.class}" if not defined?(self.to_xml)
    raise "url not defined for #{self.class}" if not self.url
    raise "from_xml not defined for #{response_class}" if not defined?(response_class.from_xml)
 
    @request_xml = self.to_xml_etc
    
    http, uri = Helper.http_from_url(self.url)
    head = defined?(self.headers) ? self.headers : {}
    
    puts "\n##### Request to #{url}:\n\n#{@request_xml}\n" if $DEBUG
    debugger if $POST_DEBUGGER
    resp = http.post(uri.request_uri, @request_xml, head)
    
    if resp.response.code == "302" # moved
      puts "\n##### Redirected to #{resp['Location']}\n" if $DEBUG
      http, uri = Helper.http_from_url(resp['Location'])
      resp = http.post(uri.request_uri, @request_xml, head)
    end
    
    @response_xml = resp.body
    puts "\n##### Response:\n\n#{Helper.tidy(@response_xml)}\n" if $DEBUG
 
    check_request_error(@response_xml)
 
    return response_class.from_xml(@response_xml)
  end
  
  def self.do(args = {})
    self.new(args).do
  end
  
  # Gets called during do instead of just to_xml, and does a bit more than
  # just return xml.
  # 
  # First, it calls before_to_xml if it has been defined.
  # Then it calls check_required, then returns the results of to_xml sans
  # empty nodes (see Helper.compact_xml).
  # 
  # You can set a COMPACT_XML constant to false to avoid the latter behavior,
  # but most APIs complain when you send them empty nodes (even if the nodes
  # were optional to begin with).
  def to_xml_etc
    self.before_to_xml if defined?(before_to_xml)
    self.check_required
    xml = self.to_xml
    return (defined?(COMPACT_XML) && !COMPACT_XML) ? xml : Helper.compact_xml(xml)
  end
 
  # returns self.class.response_class as a constant (not a string)
  #
  # Raises a runtime error if self.class.response_class is nil
  def response_class
    ret = self.class.response_class
    raise "Invalid response_class; see docs for naming conventions etc" if !ret
    return Object.const_get(ret)
  end
 
  def error_paths
    self.class.error_paths
  end
 
  def required
    self.class.required
  end
 
  def yaml_defaults
    self.class.yaml_defaults
  end
 
  def url
    self.class.url
  end
 
  def defaults
    self.class.defaults
  end
  
  def config_root
    if defined?(RAILS_ROOT)
      RAILS_ROOT + "/config"
    else
      "config"
    end
  end

protected

  # Will raise a RequiredFieldError if an attribute in self.required is nil
  def check_required
    return if self.required.nil?
 
    self.required.each do |attribute|
      if eval("@#{attribute}").nil?
        raise RequiredFieldError, "#{attribute} needs to be set"
      end
    end
  end

private

  # If the xml contains an error notification, this'll raise a
  # RequestError with the xml error code and message as defined in
  # the options in error_paths. Returns nil otherwise.
  def check_request_error(xml)
    return if !error_paths
    return if !xml || !xml.include?('<?xml')
 
    response_doc = LibXML::XML::Parser.string(xml).parse
    error = response_doc.find_first(error_paths[:root])
    return if error.nil? || error.empty?
 
    code = error.find_first(error_paths[:code]).first.content
    message = error.find_first(error_paths[:message]).first.content
 
    raise RequestError, "Code #{code}: #{message}"
  end
  
  def builder # :nodoc:
    @builder ||= Builder::XmlMarkup.new(:target => @xml, :indent => 2)
  end
  alias :b :builder
 
 
  # set instance variables based on a hash, i.e. @key = value
  def initialize_attrs(attrs)
    attrs.each do |attr, value|
      self.instance_variable_set("@#{attr}", value)
    end
  end
  
  def symbolize_keys(*hashes)
    hashes.each do |hash|
      hash.each {|k,v| hash[k.to_sym] = v;hash.delete(k.to_s)}
    end
  end
end