# Phantom::Manager

phantom-manager allows you to use multiple phantom-js processes behind an Nginx
server. It will manage both presence and memory consumption of those processes
and kill them when appropriate, all this in sync with the Nginx configuration
so that all requests will get answered.

## Installation

Add this line to your application's Gemfile:

    gem 'phantom-manager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phantom-manager

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
