# frozen_string_literal: true

require 'fileutils'

def log(message)
  puts "[extconf.rb] #{message}"
end

log 'Checking for StormLib...'
STORMLIB_DIR = File.expand_path('../StormLib', __FILE__)

if File.directory?(STORMLIB_DIR) && File.exist?(File.join(STORMLIB_DIR, 'src', 'StormLib.h'))
  log 'StormLib found!'
else
  log "Cannot find StormLib directory in #{STORMLIB_DIR}"

  system "git clone https://github.com/ladislav-zezula/StormLib.git #{STORMLIB_DIR}" or raise 'Failed to clone StormLib'
end

# Compile StormLib
Dir.chdir(STORMLIB_DIR) do
  log 'Configuring StormLib with CMake...'
  system('cmake . -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_C_FLAGS="-Wno-old-style-definition" -DBUILD_SHARED_LIBS=OFF') or raise 'Failed to configure StormLib with CMake'

  log 'Cleaning previous build...'
  system('make clean') or log 'Warning: make clean failed, but continuing...'

  log 'Building StormLib...'
  system('make') or raise 'Failed to build StormLib'
end

# Find the library file
lib_file = Dir.glob("#{STORMLIB_DIR}/**/{libstorm.a,libstorm.so}").first

if lib_file.nil?
  raise "Cannot find libstorm.a or libstorm.so in #{STORMLIB_DIR}"
end

lib_dir = File.dirname(lib_file)
lib_name = File.basename(lib_file).sub(/^lib/, '').sub(/\.(a|so)$/, '')

log "Found StormLib: #{lib_file}"

require 'mkmf'

# Set up the extension
$CFLAGS << " -I#{STORMLIB_DIR}/src -fPIC"
$LDFLAGS << " -L#{lib_dir} -l#{lib_name} -lz -lbz2 -lstdc++"

# Adjust the library path
$LDFLAGS << " -Wl,-rpath,#{lib_dir}"

# Ensure the compiler can find necessary headers and libraries
dir_config('stormlib', "#{STORMLIB_DIR}/src", lib_dir)

unless have_library(lib_name)
  log "Unable to find #{lib_name} library. Contents of #{lib_dir}:"
  Dir.foreach(lib_dir) { |f| log "  #{f}" }
  raise "Unable to find #{lib_name} library"
end

unless have_library('z')
  log 'Trying to find zlib in system directories...'
  raise 'Unable to find zlib' unless find_library('z', 'deflate')
end

unless have_library('bz2')
  log 'Trying to find bzip2 in system directories...'
  raise 'Unable to find bzip2 library' unless find_library('bz2', 'BZ2_bzCompress')
end

# Create the makefile
log 'Creating Makefile...'
create_makefile('stormlib/stormlib')

log 'extconf.rb completed successfully'
