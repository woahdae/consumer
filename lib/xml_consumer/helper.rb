module XmlConsumer::Helper
  # if you pass in a newline-less glob of xml it'll return an indented copy
  # for improved readability (just returns the xml as is otherwise)
  def self.tidy(xml)
    return xml if xml =~ /\n/ # if newlines are present, it might not need tidying
    
    xml = xml.clone # avoid modifying @response_xml due to pass by reference
    
    # replace empty tag pairs with <tag/>
    xml.gsub!(/\<(\w*?)\>\<\/\1\>/, "<\\1/>")
    # add in newlines after >, and sometimse before <
    xml.gsub!(/\>/,">\n").gsub!(/([^\<\>\n])\</,"\\1\n<")
    
    ### add appropriate spacing before each newline ###
    tab = -1
    last_indent = nil
    return xml.collect do |line|
      next line if line =~ /\<\?xml/ # skip indenting this
      
      # calculate the indentation #
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
      
      # save indent for next time to deal with the siblings case (see above) #
      last_indent = indent
      
      # return line with appropriate amount of preceding spaces #
      line = "  " * tab.abs + line
    end.join
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

  # returns a hash of defaults if +self.defaults_yaml+ is defined and the file
  # defined there exists, empty hash otherwise.
  def self.hash_from_yaml(file, namespace = nil)
    defaults_exist = file && File.exists?(file)
    hash = defaults_exist ? YAML.load(File.read(file)) : {}
    return namespace ? hash[namespace] : hash
  end
  
end