# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fax_finder}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erich L. Timkar"]
  s.date = %q{2011-05-02}
  s.email = %q{erich@hordesoftware.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".project",
    "Changelog",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "fax_finder.gemspec",
    "fax_finder.tmproj",
    "lib/fax_finder.rb",
    "lib/fax_finder/query.rb",
    "lib/fax_finder/request.rb",
    "lib/fax_finder/response.rb",
    "lib/fax_finder/send.rb",
    "pkg/fax_finder-0.1.0.gem",
    "test/fixtures/send_request_external.xml",
    "test/fixtures/send_request_inline.xml",
    "test/fixtures/send_response_success.xml",
    "test/query_test.rb",
    "test/request_test.rb",
    "test/response_test.rb",
    "test/send_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/erichhorde/fax_finder}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fax_finder}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Provides support MultiTech's FaxFinder server}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["= 1.4.4"])
      s.add_runtime_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_development_dependency(%q<test-unit>, ["~> 2"])
      s.add_development_dependency(%q<mocha>, [">= 0.9"])
    else
      s.add_dependency(%q<nokogiri>, ["= 1.4.4"])
      s.add_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_dependency(%q<test-unit>, ["~> 2"])
      s.add_dependency(%q<mocha>, [">= 0.9"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["= 1.4.4"])
    s.add_dependency(%q<builder>, ["~> 2.1.2"])
    s.add_dependency(%q<test-unit>, ["~> 2"])
    s.add_dependency(%q<mocha>, [">= 0.9"])
  end
end

