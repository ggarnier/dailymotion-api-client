# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dailymotion-api/version'

Gem::Specification.new do |gem|
  gem.name          = "dailymotion-api-client"
  gem.version       = DailymotionApi::VERSION
  gem.authors       = ["Guilherme Garnier"]
  gem.email         = ["guilherme.garnier@gmail.com"]
  gem.description   = %q{DailyMotion API Ruby client}
  gem.summary       = %q{DailyMotion API Ruby client}
  gem.homepage      = "http://github.com/ggarnier/dailymotion-api-client"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "httmultiparty"

  gem.add_development_dependency "rspec"
end
