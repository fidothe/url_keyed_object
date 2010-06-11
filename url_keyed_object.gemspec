# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "url_keyed_object"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Patterson"]
  s.date = "2010-06-11"
  s.description = %q{Making it easy to work with Rails objects which use a URL key in their URL instead of their database ID.}
  s.email = "matt@reprocessed.org"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = Dir.glob([
    "VERSION",
    "README.rdoc",
    "LICENSE",
    "Rakefile",
    "cucumber.yml",
    "lib/**/*.rb",
    "rails/**/*.rb"
  ])
  s.homepage = "http://github.com/fidothe/url_keyed_object"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.6"
  s.summary = %q{Making it easy to work with objects with URL keys}
  s.test_files = Dir.glob([
    "spec/spec.opts",
    "spec/**/*.rb",
    "features/**/*.rb",
    "features/**/*.feature"
  ])
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
    
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<cucumber>, [">= 0.5"])
      s.add_development_dependency(%q<activerecord>, [">= 2.3"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<cucumber>, [">= 0.5"])
      s.add_dependency(%q<activerecord>, [">= 2.3"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<cucumber>, [">= 0.5"])
    s.add_dependency(%q<activerecord>, [">= 2.3"])
  end
end

