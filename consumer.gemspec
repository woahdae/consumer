Gem::Specification.new do |s|
  s.name = %q{consumer}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Woody Peterson"]
  s.date = %q{2008-11-13}
  s.default_executable = %q{consumer}
  s.description = %q{FIX (describe your package)}
  s.email = ["woody.peterson@gmail.com"]
  s.executables = ["consumer"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "app_generators/consumer/templates/README.rdoc", "examples/active_record/README.txt", "website/index.txt"]
  s.files = [".git/COMMIT_EDITMSG", ".git/HEAD", ".git/config", ".git/description", ".git/hooks/applypatch-msg", ".git/hooks/commit-msg", ".git/hooks/post-commit", ".git/hooks/post-receive", ".git/hooks/post-update", ".git/hooks/pre-applypatch", ".git/hooks/pre-commit", ".git/hooks/pre-rebase", ".git/hooks/prepare-commit-msg", ".git/hooks/update", ".git/index", ".git/info/exclude", ".git/logs/HEAD", ".git/logs/refs/heads/master", ".git/logs/refs/remotes/origin/master", ".git/objects/0c/8ee8adc6dc46ef230cac842941dfeb3be30893", ".git/objects/13/b984003c2a7a98d0451b71da3d5dfdf9a471ae", ".git/objects/28/f472b5a6d117a1e79dcdf23bb4ccefc883a4d3", ".git/objects/36/30f87bf9cd41dfdc7e0b01375d787e343ccfd3", ".git/objects/37/42cb898ef0d65419eb680deca5c6491b865cee", ".git/objects/3b/1638fe0b2e505bdf0abe2177661462a03cd508", ".git/objects/46/7eb188235d2bf58dc3bf20ef0c24a3dc388c27", ".git/objects/49/12dd808096cf0dd8bd3dba6afd1f7563d9cdd3", ".git/objects/5a/704561028999e1a3f71a7156c4c2dae8271d26", ".git/objects/65/b5cb24518e454fa2e56dc42932990a14a14cca", ".git/objects/7f/1ac1fae335fbf8c80d5689c5cefea0088ee560", ".git/objects/94/4c7329d02b93883dedac143bba82bedb70e63a", ".git/objects/a9/fc23f602aada377194883df89d71cec46a97bb", ".git/objects/ad/e917f006042c2f92acf4d9b25536c62524853f", ".git/objects/af/a52f94633039f1b5ea4e97d6a48becdec5609b", ".git/objects/c3/51f6a72670b9176fdc3ebf30ebc337cbade066", ".git/objects/c5/dcdab07df646557395c009550fa51c8b67f4d6", ".git/objects/cd/85e72451d9afb4bbf8cb74db4869ad66d3cc22", ".git/objects/e3/a3cb7e21d8daa51cd10e3d29855dd46ca1fe76", ".git/objects/f2/29dd3dee586e623e50267184e66bf6bbc6cc37", ".git/objects/f7/cb7968f1fd9cba498b76333a813d011488f4f3", ".git/objects/pack/pack-87ac9dad8a7751c5c4c30a1a68dd939d41717f30.idx", ".git/objects/pack/pack-87ac9dad8a7751c5c4c30a1a68dd939d41717f30.keep", ".git/objects/pack/pack-87ac9dad8a7751c5c4c30a1a68dd939d41717f30.pack", ".git/refs/heads/master", ".git/refs/remotes/origin/HEAD", ".git/refs/remotes/origin/master", ".gitignore", "History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "app_generators/consumer/USAGE", "app_generators/consumer/consumer_generator.rb", "app_generators/consumer/templates/.gitignore", "app_generators/consumer/templates/LICENSE", "app_generators/consumer/templates/README.rdoc", "app_generators/consumer/templates/Rakefile", "app_generators/consumer/templates/TODO", "app_generators/consumer/templates/config/config.yml", "app_generators/consumer/templates/config/config.yml.sample", "app_generators/consumer/templates/lib/base.rb", "app_generators/consumer/templates/rails/init.rb", "app_generators/consumer/templates/script/destroy", "app_generators/consumer/templates/script/generate", "app_generators/consumer/templates/spec/spec_helper.rb", "app_generators/consumer/templates/spec/ups_rate_request_spec.rb", "app_generators/consumer/templates/spec/xml/ups_rate_response.xml", "bin/consumer", "config/website.yml.sample", "consumer.gemspec", "consumer_generators/request/USAGE", "consumer_generators/request/request_generator.rb", "consumer_generators/request/templates/lib/request.rb", "consumer_generators/request/templates/lib/response.rb", "consumer_generators/request/templates/spec/request_spec.rb", "consumer_generators/request/templates/spec/response_spec.rb", "consumer_generators/request/templates/spec/xml/response.xml", "examples/active_record/README.txt", "examples/active_record/ar_spec.rb", "examples/active_record/database.sqlite", "examples/active_record/environment.rb", "examples/active_record/migration.rb", "examples/active_record/models/book.rb", "examples/active_record/models/contributor.rb", "examples/active_record/xml/book.xml", "examples/active_record/xml/book_with_contributors.xml", "examples/active_record/xml/contributor.xml", "examples/active_record/xml/contributor_with_books.xml", "examples/shipping/.gitignore", "examples/shipping/environment.rb", "examples/shipping/rate.rb", "examples/shipping/shipping.yml.sample", "examples/shipping/shipping_spec.rb", "examples/shipping/ups_rate_request.rb", "examples/shipping/ups_rate_response.xml", "lib/consumer.rb", "lib/consumer/helper.rb", "lib/consumer/mapping.rb", "lib/consumer/request.rb", "script/console", "script/destroy", "script/generate", "script/txt2html", "spec/helper_spec.rb", "spec/mapping_spec.rb", "spec/request_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/xml/rate_response.xml", "spec/xml/rate_response_error.xml", "tasks/rspec.rake", "test/test_consumer_generator.rb", "test/test_generator_helper.rb", "test/test_request_generator.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.html.erb"]
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
