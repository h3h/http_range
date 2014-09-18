# HTTPRange

A library to parse an HTTP `Range` header with semantics similar to
[Heroku's Range headers][1].

 [1]: https://devcenter.heroku.com/articles/platform-api-reference#ranges

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

## Contributing

1. Fork it ( https://github.com/[my-github-username]/http_range/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
