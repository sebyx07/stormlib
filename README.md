# StormLib 🌪️

StormLib is a Ruby gem that provides a wrapper for the [StormLib C++ library](https://github.com/ladislav-zezula/StormLib), allowing you to work with MPQ (Mo'PaQ) archives in your Ruby projects for World of Warcraft and other Blizzard games.

## 📦 Installation

Add this line to your application's Gemfile:

```ruby
gem 'stormlib'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install stormlib
```

## 🛠️ Dependencies

Before installing the gem, make sure you have the following dependencies installed on your system:

- zlib1g-dev
- libbz2-dev
- build-essential
- libstdc++-12-dev

You can install these on Ubuntu or Debian-based systems with:

```
$ sudo apt-get install zlib1g-dev libbz2-dev build-essential libstdc++-12-dev
```

## 🚀 Usage

Here are some examples of how to use StormLib:

```ruby
require 'stormlib'

# Open an existing MPQ archive
archive = StormLib::Archive.new('game.mpq')

# List files in the archive
files = archive.list_files
puts "Files in the archive: #{files.join(', ')}"

# Extract a file from the archive
archive.extract_file('readme.txt', 'extracted_readme.txt')

# Create a new MPQ archive
new_archive = StormLib::Archive.new('new_archive.mpq', create: true)

# Add a file to the new archive
new_archive.add_file('local_file.txt', 'archived_file.txt')

# Don't forget to close the archives when you're done
archive.close
new_archive.close
```

## 🧪 Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sebyx07/stormlib. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sebyx07/stormlib/blob/master/CODE_OF_CONDUCT.md).

## 📜 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 👥 Code of Conduct

Everyone interacting in the StormLib project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sebyx07/stormlib/blob/master/CODE_OF_CONDUCT.md).