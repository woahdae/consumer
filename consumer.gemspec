# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{consumer}
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Woody Peterson"]
  s.date = %q{2009-02-05}
  s.default_executable = %q{consumer}
  s.description = %q{Consumer is a library for consuming xml resources via Builder, libxml, and some request sending / response marshaling glue. It comes with an app generator that creates an empty ready-for-rails gem that itself comes with a generator for making the request/response classes, config files, and specs (see script/generate after creating a new Consumer project).}
  s.email = ["woody.peterson@gmail.com"]
  s.executables = ["consumer"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "app_generators/consumer/templates/README.rdoc", "examples/active_record/README.txt", "website/index.txt"]
  s.files = ["History.txt", "LICENSE", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "app_generators/consumer/USAGE", "app_generators/consumer/consumer_generator.rb", "app_generators/consumer/templates/LICENSE", "app_generators/consumer/templates/README.rdoc", "app_generators/consumer/templates/Rakefile", "app_generators/consumer/templates/TODO", "app_generators/consumer/templates/config/config.yml", "app_generators/consumer/templates/config/config.yml.sample", "app_generators/consumer/templates/lib/base.rb", "app_generators/consumer/templates/rails/init.rb", "app_generators/consumer/templates/script/destroy", "app_generators/consumer/templates/script/generate", "app_generators/consumer/templates/spec/spec_helper.rb", "bin/consumer", "config/website.yml.sample", "consumer.gemspec", "consumer_generators/request/USAGE", "consumer_generators/request/request_generator.rb", "consumer_generators/request/templates/lib/request.rb", "consumer_generators/request/templates/lib/response.rb", "consumer_generators/request/templates/spec/request_spec.rb", "consumer_generators/request/templates/spec/response_spec.rb", "consumer_generators/request/templates/spec/xml/response.xml", "examples/active_record/README.txt", "examples/active_record/ar_spec.rb", "examples/active_record/database.sqlite", "examples/active_record/environment.rb", "examples/active_record/migration.rb", "examples/active_record/models/book.rb", "examples/active_record/models/contributor.rb", "examples/active_record/xml/book.xml", "examples/active_record/xml/book_with_contributors.xml", "examples/active_record/xml/contributor.xml", "examples/active_record/xml/contributor_with_books.xml", "examples/shipping/environment.rb", "examples/shipping/rate.rb", "examples/shipping/shipping.yml.sample", "examples/shipping/shipping_spec.rb", "examples/shipping/ups_rate_request.rb", "examples/shipping/ups_rate_response.xml", "lib/consumer.rb", "lib/consumer/helper.rb", "lib/consumer/mapping.rb", "lib/consumer/request.rb", "rails_generators/request/USAGE", "rails_generators/request/request_generator.rb", "script/console", "script/destroy", "script/generate", "script/txt2html", "spec/helper_spec.rb", "spec/mapping_spec.rb", "spec/request_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/xml/rate_response.xml", "spec/xml/rate_response_error.xml", "tasks/rspec.rake", "test/test_consumer_generator.rb", "test/test_consumer_plugin_request_generator.rb", "test/test_generator_helper.rb", "test/test_rails_request_generator.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.html.erb"]
  s.has_rdoc = true
  s.homepage = %q{http://consumer.rubyforge.org}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{consumer}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Consumer is a library for consuming xml resources via Builder, libxml, and some request sending / response marshaling glue}
  s.test_files = ["test/test_consumer_generator.rb", "test/test_generator_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_runtime_dependency(%q<libxml-ruby>, [">= 0.8.3"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_dependency(%q<libxml-ruby>, [">= 0.8.3"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.0.2"])
    s.add_dependency(%q<libxml-ruby>, [">= 0.8.3"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<newgem>, [">= 1.1.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
