# -*- encoding: utf-8 -*-
# stub: dox-style 1.0.29 ruby lib

Gem::Specification.new do |s|
  s.name = "dox-style".freeze
  s.version = "1.0.29"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://doximity.jfrog.io/doximity/api/gems/gems-local" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["James Klein".freeze]
  s.date = "2019-02-27"
  s.email = ["kleinjm007@gmail.com".freeze]
  s.homepage = "https://github.com/doximity/dox-style".freeze
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Shared Doximity Rubocop styles".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_development_dependency(%q<generator_spec>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
      s.add_development_dependency(%q<sdoc>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rubocop>.freeze, ["~> 0.56"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_dependency(%q<generator_spec>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
      s.add_dependency(%q<sdoc>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.56"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<generator_spec>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
    s.add_dependency(%q<sdoc>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.56"])
  end
end
