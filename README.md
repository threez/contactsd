# WIP: Contactsd (for macOS)

A small daemon and utility that help to export adata from the macOS contacts
application. Allows direct access to all contacts, their vcards, photos and
details in json format.

**TODO:**

- Make it daemonize
- Secure it using a secret
- Export group information as well

## Usage

Simply start the daemon using

    nohup ./exe/contactsd &

Goto [http://localhost:5000/](http://localhost:5000/) and explore the RESTful
API.

More information on configuration can be found using:

    ./exe/contactsd help
    ./exe/contactsd help serve

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'contactsd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install contactsd

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/threez/contactsd.

