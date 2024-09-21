# frozen_string_literal: true

# File: ext/stormlib/extconf.rb

require 'mkmf'

puts "Checking for StormLib..."
STORMLIB_DIR = File.expand_path('../StormLib', __FILE__)
unless File.directory?(STORMLIB_DIR)
  puts "Cloning StormLib..."
  system "git clone https://github.com/ladislav-zezula/StormLib.git #{STORMLIB_DIR}"
end

Dir.chdir(STORMLIB_DIR) do
  # Configure CMake to use -fPIC
  system('cmake . -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_C_FLAGS="-Wno-old-style-definition"')
  system('make clean')  # Clean previous build
  system('make')
end

# Find the actual library file
lib_file = Dir.glob("#{STORMLIB_DIR}/**/{libstorm.a,libstorm.so}").first

if lib_file.nil?
  raise "Cannot find libstorm.a or libstorm.so in #{STORMLIB_DIR}"
end

lib_dir = File.dirname(lib_file)
lib_name = File.basename(lib_file).sub(/^lib/, '').sub(/\.(a|so)$/, '')

# Set up the extension
$CFLAGS << " -I#{STORMLIB_DIR}/src -fPIC"
$LDFLAGS << " -L#{lib_dir} -l#{lib_name}"

# On some systems, you might need to adjust the library path
$LDFLAGS << " -Wl,-rpath,#{lib_dir}"

# Make sure the compiler can find the necessary headers and libraries
dir_config('stormlib', "#{STORMLIB_DIR}/src", lib_dir)

have_library(lib_name) or raise "Unable to find #{lib_name} library"

create_makefile('stormlib/stormlib')
