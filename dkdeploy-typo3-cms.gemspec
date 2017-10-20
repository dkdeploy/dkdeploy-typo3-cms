lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dkdeploy/typo3/cms/version'

Gem::Specification.new do |spec|
  spec.name          = 'dkdeploy-typo3-cms'
  spec.version       = Dkdeploy::Typo3::Cms::Version
  spec.authors       = ['Kieran Hayes', 'Timo Webler', 'Nicolai Reuschling', 'Luka Lüdicke']
  spec.email         = %w[kieran.hayes@dkd.de timo.webler@dkd.de nicolai.reuschling@dkd.de luka.luedicke@dkd.de]
  spec.description   = 'dkd TYPO3 deployment tasks and strategies'
  spec.summary       = 'dkd TYPO3 deployment tasks and strategies'
  spec.homepage      = 'https://github.com/dkdeploy/dkdeploy-typo3-cms'
  spec.required_ruby_version = '~> 2.2'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin\/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)\/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'cucumber', '~> 2.4'
  spec.add_development_dependency 'rubocop', '0.50.0'
  spec.add_development_dependency 'aruba', '~> 0.14.1'
  spec.add_development_dependency 'mysql2', '~> 0.3'
  spec.add_development_dependency 'dkdeploy-test_environment', '~> 2.0'

  spec.add_dependency 'dkdeploy-php', '~> 7.0'
  spec.add_dependency 'phpass-ruby', '~> 0.1'
end
