require 'ruby-debug'
module XmlConsumer::Mapping
  def self.included(base)
    base.extend ClassMethods
  end
  
  ##
  # === Attributes
  # [+base_path+] The base path that you can find the relevant information from.
  #               Also, uniquely identifies the map for a particular xml
  #               response in the case of multiple maps.
  # [+registry+]  A hash of attribute => xpath pairs that associate an object's
  #               attributes with xml leaf nodes found under the base path, ex
  #               
  #               <code>
  #               {
  #                 :name => "CustomerName",
  #                 :city => "Address/City"
  #                 :state => "Address/State"
  #               }
  #               </code>
  class Map
    attr_accessor :base_path, :registry, :associations, :block
    
    def initialize(base_path, registry = {}, *associations, &block)
      self.registry = registry
      self.base_path = base_path
      self.associations = associations
      self.block = block
    end
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
    klass ||= association.to_s.capitalize.singularize.constantize 

    association_instance = klass.from_xml(xml)
    return if association_instance.nil?
    
    self.send(association.to_s + "=", association_instance)
  end
  
  module ClassMethods
    def maps
      @maps ||= []
    end

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
    
    def from_xml_via_map(xml)
      nodes, map = find_nodes_and_map(xml)
      return nil if map.nil?
      instances = []

      nodes.each do |node|
        attrs = attrs_from_node_and_registry(node, map[:registry])
        instance = self.from_hash(attrs)
        
        map[:associations].each do |association|
          # TODO: spec
          instance.association_from_xml(xml, association)
        end
        
        map[:block].call(instance) if map[:block]
        instances << instance
      end
      
      return map[:all] ? instances : instances.first
    end
    
    # you should be able to override this to what you want
    def from_xml(xml)
      from_xml_via_map(xml)
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
    # two-member array of the form [[LibXML::XML::XPath::Object], XmlConsumer::Mapping::Map]
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
    # (LibXML::XML::XPath::Object and XmlConsumer::Mapping::Map#registry, respectively)
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