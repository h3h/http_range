# HTTPRange

A library to parse an HTTP `Range` header for HTTP APIS with semantics
described in [SPEC][1].

 [1]: https://github.com/h3h/http_range/blob/master/SPEC.md

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_range'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_range

## Usage

```ruby
http_range = HTTPRange.parse('Range: id 29f99177-36e9-466c-baef-f855e1ab731e..29f99177-36e9-466c-baef-f855e1ab731e[; max=100')

http_range.attribute       # => "id"
http_range.first           # => "29f99177-36e9-466c-baef-f855e1ab731e"
http_range.last            # => "29f99177-36e9-466c-baef-f855e1ab731e"
http_range.max             # => "100"
http_range.order           # => nil
http_range.first_inclusive # => true
http_range.last_inclusive  # => false
```

Or, in a Rack app:

```ruby
# Range: id a..z[; max=100
# found in env['HTTP_RANGE']
app = Rack::Builder.app do
  use HTTPRange::Middleware::AcceptRanges

  run lambda do |env|

    env['rack.range.attribute']       # => 'id'
    env['rack.range.first']           # => 'a'
    env['rack.range.last']            # => 'z'
    env['rack.range.first_inclusive'] # => true
    env['rack.range.last_inclusive']  # => false
    env['rack.range.order']           # => nil
    env['rack.range.max']             # => '100'

    [200, {}, "Body"]
  end
end
```

## Inspiration

Inspired by Heroku's [Interagent HTTP API Design][2] as well as brandur's
[HTTPAccept][3] library.

 [2]: https://github.com/interagent/http-api-design
 [3]: https://github.com/brandur/http_accept

## Contributing

1. Fork it ( https://github.com/[my-github-username]/http_range/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
