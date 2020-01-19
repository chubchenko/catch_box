# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "catch_box/version"

Gem::Specification.new do |spec|
  spec.name = "catch_box"
  spec.version = CatchBox::VERSION
  spec.authors = ["Artem Chubchenko"]
  spec.email = ["artem.chubchenko@gmail.com"]

  spec.summary = "A lightweight and straightforward system for easy hooks set up"
  spec.description = spec.summary
  spec.homepage = "https://github.com/chubchenko/catch_box"
  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/chubchenko/catch_box/issues",
    "changelog_uri" => "https://github.com/chubchenko/catch_box/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/chubchenko/catch_box/tree/v#{spec.version}"
  }

  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_development_dependency "bundler", "~> 2.1", ">= 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0", ">= 13.0.1"
  spec.add_development_dependency "rspec", "~> 3.9"
end
