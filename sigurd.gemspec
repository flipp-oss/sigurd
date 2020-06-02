# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sigurd/version'

Gem::Specification.new do |spec|
  spec.name          = 'sigurd'
  spec.version       = Sigurd::VERSION
  spec.authors       = ['Daniel Orner']
  spec.email         = ['daniel.orner@flipp.com']
  spec.summary       = 'Small gem to manage executing looping processes and signal handling.'
  spec.homepage      = ''
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('concurrent-ruby', '~> 1')
  spec.add_runtime_dependency('exponential-backoff')

  spec.add_development_dependency('guard', '~> 2')
  spec.add_development_dependency('guard-rspec', '~> 4')
  spec.add_development_dependency('guard-rubocop', '~> 1')
  spec.add_development_dependency('rspec', '~> 3')
  spec.add_development_dependency('rspec_junit_formatter', '~>0.3')
  spec.add_development_dependency('rubocop', '~> 0.72')
  spec.add_development_dependency('rubocop-rspec', '~> 1.27')
end
