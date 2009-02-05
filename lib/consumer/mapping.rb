module Consumer::Mapping
  def self.included(base)
    base.extend ClassMethods
  end
  
  ### our lone instance method ###
  
  ##
  # Same as doing:
  # 
  # <code>self.association(s) = Association.from_xml(xml)</code>
  # === Behaviors
  # * sets the association to a call to Klass.from_xml
  # === Parameters
  # [+xml+]         String of xml
  # [+association+] The association name (i.e. self.something)
  # [+klass+]       The association class (i.e. Something.from_xml). 
  #                 Defaults to singular, capitalized +association+.
  # === Returns
  # Nothing in particular
  def association_from_xml(xml, association, klass = nil)
    klass ||= association.to_s.capitalize.singularize.camelcase.constantize 

    association_instance = klass.from_xml(xml)
    return if association_instance.nil?
    
    self.send(association.to_s + "=", association_instance)
  end
  
  module ClassMethods
    # Creates a new mapping hash in self.maps
    # === Parameters
    # The parameters here are used to add a new mapping hash to self.maps, which
    # in turn is used by from_xml_via_map to instantiate new objects
    # [+first_or_all+] If +:all+, from_xml_via_map will return an array instead
    #                  of a single instance (i.e. sets map[:all] to true)
    # [+base_path+]    A fully qualified xpath, such as //SomethingResponse/bah.
    #                  Also, uniquely identifies the map for a particular xml
    #                  response in the case of multiple maps.
    # [+registry+]     A hash of :attribute => 'xpath' pairs. Xpaths are
    #                  relative to +base_path+, but fully qualified xpaths are
    #                  also valid.
    #                  
    #                  For example, if the base path was //Response/Bah and the
    #                  registry was {:foo => "FooElm"}, then from_xml_via_map
    #                  will set instance.foo to the value at
    #                  //Response/Bah/FooElm in the xml. However, if you set
    #                  {:foo => "//Response/Woot/Ack"}, then it will pull the
    #                  value from //Response/Woot/Ack (not
    #                  //Response/Bah/Response/Woot/Ack).
    # [+options+]      Valid options are:
    #                  * +:include+ - sets map[:associations], which is an
    #                    array of parameters to association_from_xml
    # [+block+]        In from_xml_via_map this gets called with the new 
    #                  instance as the last step of instantiation.
    # === Returns
    # The newly created map
    # === Raises
    # * RuntimeError if the base path is already defined in another mapping
    #   in the class
    def map(first_or_all, base_path, registry, options = {}, &block)
      if self.maps.find {|m| m[:base_path] == base_path}
        raise "Base path exists: #{base_path}" 
      end
      
      map = {
        :all => first_or_all == :all ? true : false,
        :base_path => base_path,
        :registry => registry,
        :associations => [*options[:include]].compact,
        :block => block
      }
      self.maps << map
      
      return map
    end
    
    # Returns @maps or []
    def maps
      @maps ||= []
    end
    
    # Pulls attributes from the xml using xpaths defined in the mapping whose
    # base path matches the xml, and instantiates a new object with those attrs.
    # === Behaviors
    # * If multiple elements match the base path and map[:all] is true, it will
    #   return an array of objects.
    # * Calls from_xml on elements in map[:associations] (see
    #   association_from_xml)
    # * Calls map[:block] with the new instance (and optionally the libxml node)
    #   just before adding it to the return array for custom post-processing
    # === Returns
    # * An array of instances or a new instance depending on whether map[:all]
    #   is true or false, respectively
    def from_xml_via_map(xml)
      nodes, map = find_nodes_and_map(xml)
      return nil if map.nil?
      instances = []

      nodes.each do |node|
        attrs = attrs_from_node_and_registry(node, map[:registry])
        instance = self.from_hash(attrs)
        
        map[:associations].each do |association|
          # TODO: spec
          instance.association_from_xml(node.to_s, association)
        end
        
        b = map[:block]
        if b
          case b.arity # number of parameters
          when 1
            b.call(instance)
          when 2
            b.call(instance, node)
          end
        end
        
        return instance unless map[:all]
        instances << instance
      end
      
      return instances
    end
    
    # you can override this to what you want. Defaults to
    # an alias for from_xml_via_map.
    def from_xml(xml)
      @xml = xml
      self.before_from_xml if defined?(before_from_xml)
      from_xml_via_map(@xml)
    end
    
    # initializes a new instance of self and uses the attribute setters to 
    # populate attributes from the hash. Objects inheriting from ActiveRecord
    # do this automatically in initialize, but the world doesn't (always) revolve
    # around AR
    def from_hash(attrs)
      object = self.new
    
      attrs.each do |attribute, value|
        object.send("#{attribute}=", value)
      end
    
      object
    end
  
  private
  
    # find the first map whose base path matches the xml,
    # and return the nodes found at that base path along with the map
    # === Parameters
    # [+xml+] - String of xml
    # === Returns
    # two-member array of the form [[LibXML::XML::XPath::Object], Consumer::Mapping::Map]
    # === Raises
    # nothing
    def find_nodes_and_map(xml)
      self.maps.each do |map|
        doc = LibXML::XML::Parser.string(xml).parse
        nodes = doc.find(map[:base_path])
        return nodes, map if !nodes.empty?
      end
      return [], nil
      puts "No map found in #{self.class} for xml #{xml[0..100]}..." if $DEBUG
    end
    
    # returns a hash of attribute => value pairs given an xpath node and a
    # map registry
    # (LibXML::XML::XPath::Object and Consumer::Mapping::Map#registry, respectively)
    def attrs_from_node_and_registry(node, registry)
      attrs = {}
      
      registry.each do |attribute, path|
        leaf = node.find(path).first
        attrs[attribute] = leaf.content if leaf.respond_to?(:content)
        attrs[attribute] = leaf.value if leaf.respond_to?(:value)
      end

      attrs
    end
    
  end
end