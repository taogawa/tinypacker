# Tinypacker

A tiny gem to integrate webpack with Rails

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tinypacker'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tinypacker

Finally, run the following to install 

    $ bundle exec rails tinypacker:install

## Usage

As with Webpacker, an asset manifest file is required to use Tinypacker. You need to specify the path of the asset manifest file in `manifest_path` of `tinypacker.yml`.

The format of the asset manifest file is as follows:

```json
{
  "application.js": "/packs/js/application-12345.js",
}
```

And on the view file, you can use `javascript_pack_tag`.

```
<%= javascript_pack_tag 'application.js' %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taogawa/tinypacker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/taogawa/tinypacker/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tinypacker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/taogawa/tinypacker/blob/main/CODE_OF_CONDUCT.md).
