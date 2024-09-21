# frozen_string_literal: true

require_relative 'stormlib/version'
require 'stormlib/stormlib'

module StormLib
  class Archive
    def initialize(filename, create: false, max_file_count: 1000)
      if create
        @handle = StormLib.create_archive(filename, 0, max_file_count)
      else
        @handle = StormLib.open_archive(filename, 0, 0)
      end
    end

    def close
      StormLib.close_archive(@handle)
    end

    def add_file(filename, archived_name, flags = 0)
      StormLib.add_file(@handle, filename, archived_name, flags)
    end

    def extract_file(archived_name, filename)
      StormLib.extract_file(@handle, archived_name, filename)
    end
  end
end
