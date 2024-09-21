# frozen_string_literal: true

require_relative 'lib/stormlib/version'

Gem::Specification.new do |spec|
  spec.name = 'stormlib'
  spec.version = Stormlib::VERSION
  spec.authors = ['sebi']
  spec.email = ['gore.sebyx@yahoo.com']

  spec.summary = 'MPQ library for Ruby using the StormLib C library'
  spec.description = 'MPQ library for Ruby using the StormLib C library'
  spec.homepage = 'https://github.com/sebyx07/stormlib'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.extensions = ['ext/stormlib/extconf.rb']

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  gemspec = File.basename(__FILE__)
  spec.files = Dir.glob('{lib,ext}/**/*') + %w[README.md LICENSE.txt CHANGELOG.md] + [gemspec]
  spec.files = spec.files.reject do |f|
    f.end_with?('.o', '.so')
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake-compiler', '>= 1.2.7'
  spec.add_development_dependency 'rake', '>= 13'
end
