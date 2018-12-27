# RqlParser

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rql-parser'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install rql-parser
```

## Usage

See [ActiveInteraction](https://github.com/AaronLasseigne/active_interaction), as it is used as a base for the gem

```ruby
# In controller:
output = RqlParser.from_params(params.to_unsafe_hash)

# Parse RQL instead of params: 
rql = 'eq(hello,world)&ruby=eq=awesome' # your RQL query here
output = RqlParser.parse(rql)
```

`output.result` yields a binary tree representing the query:

```ruby
rql = 'eq(hello,world)&ruby=eq=awesome' # your RQL query here
output = RqlParser.parse(rql)
output.valid?
#=> true
output.result
#=> { type: :function,
#     identifier: :and,
#     args: [{ type: :function,
#              identifier: :eq,
#              args: [{ arg: 'hello' },
#                     { arg: 'world' }] },
#            { type: :function,
#              identifier: :eq,
#              args: [{ arg: 'ruby' },
#                     { arg: 'awesome' }] }] }
```

`output.errors` yields an `ActiveModel::Errors`-like object (if any):
```ruby
rql = 'i=have=errors' # your invalid RQL query here
output = RqlParser.parse(rql)
output.valid?
#=> false
output.errors.full_messages
#=> 'Rql has invalid shorthands'
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hacky-gems/rql-parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RqlParser project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hacky-gems/rql-parser/blob/master/CODE_OF_CONDUCT.md).
