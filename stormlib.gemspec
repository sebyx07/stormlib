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
  spec.extensions  = ['ext/stormlib/extconf.rb']

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # spec.add_runtime_dependency 'ffi', '~> 1.15', '>= 1.15.0'
  spec.add_development_dependency 'rake-compiler', '>= 1.2.7'
  spec.add_development_dependency 'rake', '>= 13'
end
