# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dailymotion-api/version"

Gem::Specification.new do |gem|
  gem.name          = "dailymotion-api-client"
  gem.version       = DailymotionApi::VERSION
  gem.authors       = ["Guilherme Garnier", "Viktor Schmidt"]
  gem.email         = ["guilherme.garnier@gmail.com", "viktorianer4life@gmail.com"]
  gem.description   = "Client for DailyMotion API (http://www.dailymotion.com/doc/api/graph-api.html) written in Ruby."
  gem.summary       = "DailyMotion API Ruby client"
  gem.homepage      = "http://github.com/ggarnier/dailymotion-api-client"
  gem.license       = "MIT"

  gem.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  gem.bindir        = "bin"
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "httmultiparty", "~> 0.3.16"
  gem.add_runtime_dependency "multipart-post", "~> 2.1", ">= 2.1.1"

  gem.add_development_dependency "bundler", "~> 1.17"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "pry", "~> 0.13.1"
  gem.add_development_dependency "pry-byebug", "~> 3.9"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rubocop-rails_config", "~> 0.11.0"
  gem.add_development_dependency "rubocop", "~> 0.81.0"
end
