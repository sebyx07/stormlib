# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/extensiontask'

RSpec::Core::RakeTask.new(:spec)

STORMLIB_DIR = File.expand_path('ext/stormlib/StormLib', __dir__)

desc 'Clone or update StormLib'
task :ensure_stormlib do
  puts 'Ensuring StormLib is present...'
  if File.directory?(STORMLIB_DIR)
    puts 'Updating StormLib...'
    Dir.chdir(STORMLIB_DIR) do
      sh 'git pull'
    end
  else
    puts 'Cloning StormLib...'
    sh "git clone https://github.com/ladislav-zezula/StormLib.git #{STORMLIB_DIR}"
  end
end

Rake::ExtensionTask.new('stormlib') do |ext|
  ext.lib_dir = 'lib/stormlib'
  ext.ext_dir = 'ext/stormlib'
  ext.source_pattern = "*.{c,cpp}"
end

task :original_compile => 'compile:stormlib'

Rake::Task['compile'].clear if Rake::Task.task_defined?('compile')

desc 'Ensure StormLib and then compile'
task :compile => [:ensure_stormlib, :original_compile]
