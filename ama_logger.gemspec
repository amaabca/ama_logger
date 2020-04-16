# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ama/logger/version'

Gem::Specification.new do |spec|
  spec.name = 'ama_logger'
  spec.version = Ama::Logger::VERSION
  spec.authors = [
    'Jesse Doyle',
    'Michael van den Beuken',
    'Darko Dosenovic',
    'Zoie Carnegie',
    'Ruben Estevez'
  ]
  spec.email = [
    'jesse.doyle@ama.ab.ca',
    'michael.vandenbeuken@ama.ab.ca',
    'darko.dosenovic@ama.ab.ca',
    'zoie.carnegie@ama.ab.ca',
    'ruben.estevez@ama.ab.ca'
  ]
  spec.required_ruby_version = '>= 2.3.1'
  spec.summary = 'Implementation of AMA\'s standard logging format'
  spec.description = 'Log formatters and helper classes for the AMA standardized log format'
  spec.homepage = 'https://github.com/amaabca/ama_logger'
  spec.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    git_files = `git ls-files -z`.split("\x0")
    git_files.reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.2'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.65.0'
  spec.add_development_dependency 'simplecov'
end
