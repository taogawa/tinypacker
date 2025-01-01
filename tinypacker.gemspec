# frozen_string_literal: true

require_relative "lib/tinypacker/version"

Gem::Specification.new do |spec|
  spec.name = "tinypacker"
  spec.version = Tinypacker::VERSION
  spec.authors = ["taogawa"]
  spec.email = ["taogwjp@gmail.com"]

  spec.summary = "A tiny gem to integrate webpack with Rails"
  spec.description = spec.summary
  spec.homepage = "https://github.com/taogawa/tinypacker"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/taogawa/tinypacker"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "railties", ">= 5.2"

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rails", ">= 5.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
