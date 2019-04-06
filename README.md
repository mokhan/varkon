# Searchable

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'searchable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install searchable

## Usage

```ruby
class Lamb
  extend Searchable
end

puts Lamb.email?("email@example.org")
puts Lamb.guid?(SecureRandom.uuid)
puts Lamb.hostname?('example.com')
puts Lamb.ipv4?('192.168.1.1')
puts Lamb.ipv6?('2001:0000:1234:0000:0000:C1C0:ABCD:0876')
puts Lamb.md5?(Digest::MD5.new.hexdigest(Random.new.bytes(100)))
puts Lamb.sha1?(Digest::SHA1.new.hexdigest(Random.new.bytes(100)))
puts Lamb.sha256?(Digest::SHA2.new(256).hexdigest(Random.new.bytes(100)))
puts Lamb.url?('http://foo.com')
puts Lamb.partial_url?('www.foo.com/')
puts Lamb.mac_address?('AA-BB-CC-DD-EE-FF')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mokhan/searchable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
