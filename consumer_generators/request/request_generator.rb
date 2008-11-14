require 'active_support'
require 'yaml'
class RequestGenerator < RubiGen::Base

  default_options :author => nil

  attr_reader :request_class, :response_class, :request_file, :response_file
  attr_reader :response_xml, :request_base, :appname

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @request_base = args.shift
    @request_class = @request_base + "Request"
    @response_class = args.shift || @request_base
    @request_file = @request_class.underscore
    @response_file = @response_class.underscore
    @response_xml = @request_base.underscore + "_response.xml"
    @appname = APP_ROOT.split(/[\/\\]/).last
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory ''
      m.directory 'lib'
      m.directory "lib/#{@appname}"
      m.directory 'spec'
      m.directory 'spec/xml'
      
      templates = [
        ["lib/request.rb",        "lib/#{@appname}/#{@request_file}.rb"],
        ["lib/response.rb",       "lib/#{@appname}/#{@response_file}.rb"],
        ["spec/request_spec.rb",  "spec/#{@request_file}_spec.rb"],
        ["spec/response_spec.rb", "spec/#{@response_file}_spec.rb"],
        ["spec/xml/response.xml", "spec/xml/#{@response_xml}"]
      ]
      
      templates.each {|args| m.template *args}
      
      # put in a relevant example if the config is still empty
      if File.exists?("config/#{@appname}.yml")
        config = YAML.load(File.read("config/#{@appname}.yml"))
        File.open("config/#{@appname}.yml", "w") do |file|
          file << "all:\n  global_default: Value\n#{@request_base.underscore}:\n  request_default: Value"
        end if !config
      end
      
      # Create stubs
      # m.template           "template.rb.erb", "some_file_after_erb.rb"
      # m.template_copy_each ["template.rb", "template2.rb"]
      # m.template_copy_each ["template.rb", "template2.rb"], "some/path"
      # m.file           "file", "some_file_copied"
      # m.file_copy_each ["path/to/file", "path/to/file2"]
      # m.file_copy_each ["path/to/file", "path/to/file2"], "some/path"
    end
  end

  protected
    def banner
      <<-EOS
Creates request and response classes

USAGE: #{$0} #{spec.name} name
EOS
    end

    def add_options!(opts)
      # opts.separator ''
      # opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      # opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end