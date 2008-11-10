require 'net/http'
require 'net/https'
require 'yaml'

##
# === Attributes
# [+required+] Array of symbols for required attributes; if one is omitted,
#              +send+ will raise a RequiredFieldError
class XmlConsumer::Request
  class RequestError < StandardError;end
  class RequiredFieldError < StandardError;end
  
  attr_accessor :required
  attr_reader :response_xml, :request_xml
  
  # Loads defaults from +defaults_file+, merges them with passed in attrs
  # (which overwrite defaults in +defaults_file+), and initializes all of
  # those into instance variables for use in to_xml.
  def initialize(attrs = {})
    defaults = hash_from_yaml(defaults_file)
    initialize_attrs(defaults.merge(attrs))
    @required = self.class.instance_variable_get("@required")
  end
  
  # Sends self.to_xml to self.url and returns new object(s) created via
  # [response_class].from_xml
  # === Prerequisites
  # * All attributes in self.required must exist; raises RequiredFieldError 
  #   otherwise
  # * self.to_xml must be defined; RuntimeError otherwise
  # * self.url must be defined; RuntimeError otherwise
  # * response_class.from_xml must be defined; RuntimeError otherwise
  # === Returns
  # Whatever response_class.from_xml(@response_xml) returns, which should be
  # an object or array of objects (an array of objects if response_class is
  # using XmlConsumer::Mapping)
  def do
    check_required
    raise "to_xml not defined for #{self.class}" if not defined?(self.to_xml)
    raise "url not defined for #{self.class}" if not defined?(self.url)
    raise "from_xml not defined for #{response_class}" if not defined?(response_class.from_xml)
    
    @request_xml = self.to_xml
    uri = URI.parse self.url
    http = Net::HTTP.new uri.host, uri.port
    if uri.port == 443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    puts "\n##### Request to #{url}:\n\n#{@request_xml}\n" if $DEBUG
    @response_xml = http.post(uri.path, @request_xml).body
    
    puts "\n##### Response:\n\n#{tidy(@response_xml)}\n" if $DEBUG
    return response_class.from_xml(@response_xml)
  rescue
    check_request_error
  end
  
  # returns self.class.response_class as a constant (not a string)
  # or the default [Something]Request, ex. for a RateRequest this would
  # return the Rate constant.
  def response_class
    self.class.to_s =~ /(.+?)Request/
    ret = self.class.instance_variable_get("@response_class") || $1
    return Object.const_get(ret)
  end
  
  # Used for setting the class the request will use to parse the response.
  # Note that the +class_string+ parameter should be a string, like "Rate",
  # and not a constant (this will avoid load order issues)
  def self.response_class(class_string)
    @response_class = class_string
  end
  
  # Use this to define attributes that must be present in the Request instance
  # before calling +do+. Anything defined here but not in the instance will
  # raise a RequiredFieldError on calling +do+
  def self.required(*args)
    @required = args
  end
  
  # If you define this in your subclasses to return a hash for error options
  # (see "Options" below) they will raise informative
  # RequestError errors with xml error info in the message. 
  # 
  # If this is left undefined and the remote server returns error xml rather
  # than what you were expecting, you'll get generic xml parsing errors
  # instead of something informative.
  # 
  # Note: currently only handles one error.
  # === Options
  # All options are xpaths. All options except +:root+ are relative
  # to the root (unless prefixed with "//")
  # [+:root+]    Root element of the error(s)
  # [+:code+]    Remote API's error code for this error
  # [+:message+] Informative part of the error
  # === Example
  # <pre>
  # {
  #   :root => "//Error",
  #   :code => "ErrorCode",
  #   :message => "LongDescription"
  # }
  # </pre>
  def error_paths
    nil
  end
  
  # If you define this in your subclass to return a string for the location
  # of a yaml file it'll load 'em as instance variables on initialize.
  # Anything passed in to initialize will override these, though.
  def defaults_file
    nil
  end
  
private
  
  # returns a hash of defaults if +self.defaults_yaml+ is defined and the file
  # defined there exists, empty hash otherwise.
  def hash_from_yaml(file)
    defaults_exist = file && File.exists?(file)
    return defaults_exist ? YAML.load(File.open(file)) : {}
  end
  
  # If the response xml contains an error notification, this'll raise a
  # RequestError with the xml error code and message as defined in
  # the options in error_paths. If program error has occurred or 
  # error_paths haven't been defined, it'll re-raise the error
  # that got us here.
  def check_request_error
    raise $! if !error_paths
    raise $! if !@response_xml || !@response_xml.include?('<?xml')
    
    response_doc = LibXML::XML::Parser.string(@response_xml).parse
    error = response_doc.find_first(error_paths[:root])
    raise $! if error.empty?
    
    code = error.find_first(error_paths[:code]).first.content
    message = error.find_first(error_paths[:message]).first.content

    raise RequestError, "Code #{code}: #{message}"
  end
  
  def builder # :nodoc:
    @builder ||= Builder::XmlMarkup.new(:target => @xml, :indent => 2)
  end
  alias :b :builder
  
  # Will raise a RequiredFieldError if an attribute in self.required is nil
  def check_required
    return if required.nil?
    
    required.each do |attribute|
      if eval("@#{attribute}").nil?
        raise RequiredFieldError, "The #{attribute} variable needs to be set" 
      end
    end
  end

  # set instance variables based on a hash, i.e. @key = value
  def initialize_attrs(attrs)
    attrs.each do |attr, value|
      self.instance_variable_set("@#{attr}", value)
    end
  end
  
  # if you pass in a newline-less glob of xml it'll return an indented copy
  # for improved readability (just returns the xml as is otherwise)
  def tidy(xml)
    return xml if xml =~ /\n/ # if newlines are present, it might not need tidying
    
    xml = xml.clone # avoid modifying @response_xml due to pass by reference
    
    # replace empty tag pairs with <tag/>
    xml.gsub!(/\<(\w*?)\>\<\/\1\>/, "<\\1/>")
    # add in newlines after >, and sometimse before < #
    xml.gsub!(/\>/,">\n").gsub!(/([^\<\>\n])\</,"\\1\n<")
    
    # add appropriate spacing before each newline #
    tab = -1
    last_indent = nil
    return xml.collect do |line|
      next line if line =~ /\<\?xml/ # skip indenting this
      
      ## calculate the indentation ##
      if line =~ /\<\//
        # it's an end tag
        indent = -1
      elsif line =~ /\<.+?\/>/
        # it's an empty node, which is equivalent to
        # parsing a start tag and an end tag. Thus, we should
        # act like tab has been indented (tab += 1), and set
        # the indent to -1 (see sibling comment below)
        tab += 1
        indent = -1
      elsif line =~ /\</
        # it's a start tag
        if last_indent == -1
          # back-to-back close/start tags are siblings; no indent here
          indent = 0
        else
          # it's a child of another tag
          indent = 1
        end
      else 
        # it's a text node
        indent = 1
      end
      tab += indent
      
      ## save indent for next time to deal with the siblings case (see above) ##
      last_indent = indent
      
      ## return line with appropriate amount of preceding spaces ##
      line = "  " * tab.abs + line
    end.join
  end

end