# frozen_string_literal: true

require_relative "lib/qar/version"

Gem::Specification.new do |spec|
  spec.name          = "qar"
  spec.version       = Qar::VERSION
  spec.authors       = ["mmcs-ruby"]
  spec.email         = ["poganesyan@sfedu.ru"]

  spec.summary       = "Quantum computer simulator"
  spec.description   = "Quantum computer simulator written in Ruby using efficient C extensions for greater performance."
  spec.homepage      = "https://github.com/mmcs-ruby/qar"
  spec.license       = "MIT"
  spec.required_ruby_version = "~> 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mmcs-ruby/qar"
  spec.metadata["changelog_uri"] = "https://github.com/mmcs-ruby/qar/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
