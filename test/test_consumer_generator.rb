require File.join(File.dirname(__FILE__), "test_generator_helper.rb")

class TestConsumerGenerator < Test::Unit::TestCase
  include RubiGen::GeneratorTestHelper

  def setup
    bare_setup
  end

  def teardown
    bare_teardown
  end

  # Some generator-related assertions:
  #   assert_generated_file(name, &block) # block passed the file contents
  #   assert_directory_exists(name)
  #   assert_generated_class(name, &block)
  #   assert_generated_module(name, &block)
  #   assert_generated_test_for(name, &block)
  # The assert_generated_(class|module|test_for) &block is passed the body of the class/module within the file
  #   assert_has_method(body, *methods) # check that the body has a list of methods (methods with parentheses not supported yet)
  #
  # Other helper methods are:
  #   app_root_files - put this in teardown to show files generated by the test method (e.g. p app_root_files)
  #   bare_setup - place this in setup method to create the APP_ROOT folder for each test
  #   bare_teardown - place this in teardown method to destroy the TMP_ROOT or APP_ROOT folder after each test

  def test_generator_without_options
    run_generator('consumer', [APP_ROOT], sources)

    dirs = %w(
      lib
      lib/myproject
      rails
      script
      spec
      spec/xml
    )
    
    files = %w(
      TODO
      LICENSE
      README.rdoc
      Rakefile
      config.yml
      config.yml.sample
      lib/myproject.rb
      rails/init.rb
      script/generate
      script/destroy
      spec/spec_helper.rb
    )
    
    dirs.each { |dir| assert_directory_exists dir }
    files.each { |file| assert_generated_file file }
  end

  private
  def sources
    [RubiGen::PathSource.new(:test, File.join(File.dirname(__FILE__),"..", generator_path))
    ]
  end

  def generator_path
    "app_generators"
  end
end
