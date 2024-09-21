# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'

RSpec::Core::RakeTask.new(:spec)


Rake::ExtensionTask.new('stormlib') do |ext|
  ext.lib_dir = 'lib/stormlib'
end

task :clone_stormlib do
  unless File.directory?('ext/stormlib/StormLib')
    sh 'git submodule add https://github.com/ladislav-zezula/StormLib.git'
  end
end

task compile: :clone_stormlib

task default: :spec
