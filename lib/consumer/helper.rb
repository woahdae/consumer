module Consumer::Helper
  # if you pass in a newline-less glob of xml it'll return an indented copy
  # for improved readability.
  def self.tidy(xml)
    xml = xml.clone # avoid modifying @response_xml due to pass by reference
    
    # remove all formatting to start from a common base
    xml.gsub!(/\>[\t\n\r ]*\</, "><")
    # replace empty tag pairs with <tag/>
    xml.gsub!(/\<(\w*?)\>\<\/\1\>/, "<\\1/>")
    # add in newlines after >, and sometimse before <
    xml.gsub!(/\>\</,">\n<")
    
    declaration = /\<\?xml/
    start_tag   = /\<[^\/]+?\>[\n\t\r ]+/
    end_tag     = /^[\t ]*\<\//
    
    ## add appropriate spacing before each newline.
    tab = 0
    siblings = false
    first_tag = true
    return xml.collect do |line|
      next line if line =~ declaration
      
      # calculate the indentation.
      # In general we want to add spacing if it's a start tag or leaf node, and
      # remove spacing if it's an end tag. The only times we don't want to add
      # spacing is if it's the very first node or the previous node was a sibling
      # instead of a parent.
      if line =~ end_tag
        tab -= 1
      else
        tab += 1 unless first_tag || siblings
      end

      # if the line is a start tag, the next lines will no longer be siblings
      siblings = line =~ start_tag ? false : true
      first_tag = false
      
      # return line with appropriate amount of preceding spaces #
      line = "  " * (tab > 0 ? tab : 0) + line
    end.join << "\n"
  end
  
  # returns a copy of the xml without empty nodes. Also removes internal 
  # (non-leaf) nodes that only contain empty leaves. Nodes containing only
  # whitespace characters (space, newline, tab, and return) are considered empty.
  def self.compact_xml(xml)
    old_xml = xml
    loop do
      new_xml = old_xml.gsub(/\<(\w*?)\>[ \t\r\n]*\<\/\1\>\n?/, "")
      if old_xml == new_xml # nothing was changed
        return new_xml
      else # something changed, so we'll go through it again
        old_xml = new_xml
      end
    end
  end

  # returns a hash of defaults if +self.yaml_defaults+ is defined and the file
  # defined there exists, empty hash otherwise.
  # 
  # Also takes a namespace, i.e. a sub-hash, and when given a namespace it also
  # enables a global namespace called 'all'. Thus if you had the yaml:
  # 
  # <pre>
  # all:
  #   my_name: Buster
  # greetings:
  #   hello: world
  # other:
  #   irrelevant: data
  # </pre>
  # 
  # a namespace of 'greetings' would return the hash:
  # 
  # <code>
  # {"my_name" => "Buster", "hello" => "world"}
  # </code>
  # 
  # You don't have to use the global namespace, but if you do, it will be included
  # everywhere.
  def self.hash_from_yaml(file, namespace = nil)
    begin
      hash = file ? YAML.load(File.read("config/" + file)) : {}
    rescue => e
      raise ArgumentError, "YAML load error: #{e.message}"
    end
    
    return {} if !hash
    
    if namespace
      global = hash["all"] || {}
      namespaced_hash = hash[namespace] || {}
      hash = global.merge(namespaced_hash)
    end
    
    return hash
  end
  
  def self.http_from_url(url)
    uri = URI.parse url
    http = Net::HTTP.new uri.host, uri.port
    if uri.port == 443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    return http, uri
  end
  
end