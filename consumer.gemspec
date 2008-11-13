Gem::Specification.new do |s|
  s.name = %q{consumer}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Woody Peterson"]
  s.date = %q{2008-11-12}
  s.default_executable = %q{consumer}
  s.description = %q{FIX (describe your package)}
  s.email = ["woody.peterson@gmail.com"]
  s.executables = ["consumer"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "app_generators/consumer/templates/README.rdoc", "examples/active_record/README.txt", "website/index.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "app_generators/consumer/USAGE", "app_generators/consumer/consumer_generator.rb", "app_generators/consumer/templates/LICENSE", "app_generators/consumer/templates/README.rdoc", "app_generators/consumer/templates/Rakefile", "app_generators/consumer/templates/TODO", "app_generators/consumer/templates/config.yml", "app_generators/consumer/templates/config.yml.sample", "app_generators/consumer/templates/lib/base.rb", "app_generators/consumer/templates/rails/init.rb", "app_generators/consumer/templates/script/destroy", "app_generators/consumer/templates/script/generate", "app_generators/consumer/templates/spec/spec_helper.rb", "app_generators/consumer/templates/spec/ups_rate_request_spec.rb", "app_generators/consumer/templates/spec/xml/ups_rate_response.xml", "bin/consumer", "config/website.yml.sample", "consumer_generators/request/USAGE", "consumer_generators/request/request_generator.rb", "consumer_generators/request/templates/lib/request.rb", "consumer_generators/request/templates/lib/response.rb", "consumer_generators/request/templates/spec/request_spec.rb", "consumer_generators/request/templates/spec/response_spec.rb", "consumer_generators/request/templates/spec/xml/response.xml", "examples/active_record/README.txt", "examples/active_record/ar_spec.rb", "examples/active_record/database.sqlite", "examples/active_record/environment.rb", "examples/active_record/migration.rb", "examples/active_record/models/book.rb", "examples/active_record/models/contributor.rb", "examples/active_record/xml/book.xml", "examples/active_record/xml/book_with_contributors.xml", "examples/active_record/xml/contributor.xml", "examples/active_record/xml/contributor_with_books.xml", "examples/shipping/environment.rb", "examples/shipping/rate.rb", "examples/shipping/shipping.yml.sample", "examples/shipping/shipping_spec.rb", "examples/shipping/ups_rate_request.rb", "examples/shipping/ups_rate_response.xml", "lib/consumer.rb", "lib/consumer/helper.rb", "lib/consumer/mapping.rb", "lib/consumer/request.rb", "script/console", "script/destroy", "script/generate", "script/txt2html", "spec/helper_spec.rb", "spec/mapping_spec.rb", "spec/request_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/xml/rate_response.xml", "spec/xml/rate_response_error.xml", "tasks/rspec.rake", "test/test_consumer_generator.rb", "test/test_generator_helper.rb", "test/test_request_generator.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.html.erb"]
  s.has_rdoc = true
  s.homepage = %q{FIX (url)}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{consumer}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{FIX (describe your package)}
  s.test_files = ["test/test_consumer_generator.rb", "test/test_generator_helper.rb", "test/test_request_generator.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
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
