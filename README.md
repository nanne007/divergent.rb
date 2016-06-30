# Railway

A collection of monads for handling error in ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'railway'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install railway

## Usage

Using `Try`:

``` ruby
require 'railway'

include Railway

require 'uri'
def parse_url(url)
  Try {
    URI.parse url
  }
end

success_url = parse_url("http://www.google.com") # =>

failed_url = parse_url(':google.com') #=>

### get_or_else

failed_url.get_or_else URI('http://duckduckgo.com')

### chainable operations

# map
success_url.map(&:scheme)

failed_url.map(&:scheme)

# fmap
parse_url("http://thisisnotagoodsite.com").fmap do |url|
  Try { Net::HTTP.get(url) }
end

# each
parse_url("http://google.com").each { |url| p url }

# filter
parse_url("http://google.com").filter { |url| url.scheme == "http" }

# recover from error
failed_url.recover do |error|
  case error
  when NoMethodError
    :no_method
  when StandardError
    :standard_error
  else
    :others
  end
end
```


`Maybe` has similar interface to `Try`.
`Maybe` uses `None` instead of `Failure`.

``` ruby
# provide default value
user = Maybe.unit User.find('a_non_exist_id')
user.get_or_else(default_user)
user.or_else(Maybe.unit User.find_by_name("username"))

# usage as a collection
user.each { |u| p u}
user.map(&:age)
user.fmap { |u| Maybe(u.gender) }
user.filter { |u| u.age > 20 }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lerencao/railway.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

