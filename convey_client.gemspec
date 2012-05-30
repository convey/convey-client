require 'bundler'

Gem::Specification.new do |s|
  s.name = %q{convey_client}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anthony Langhorne"]
  s.date = %q{2012-05-30}
  s.email = %q{conveyisawesome@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "lib/convey_client.rb",
    "lib/convey_client/item.rb",
    "lib/convey_client/items.rb",
    "lib/convey_client/request.rb",
    "lib/convey_client/request_error.rb",
  ]
  s.homepage = %q{http://github.com/convey/convey-client}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{An API client for convey.io}
  s.test_files = [
    "spec/convey_client_spec.rb",
    "spec/convey_client/item_spec.rb",
    "spec/convey_client/items_spec.rb",
    "spec/convey_client/request_spec.rb",
    "spec/spec_helper.rb"
  ]

  s.add_dependency "moneta"
  s.add_dependency "json"
end

