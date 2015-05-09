# Minimist ![Build Status](https://api.travis-ci.org/ConnorAtherton/minimist.svg)

A tiny ruby ARGV parser.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minimist'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minimist

## Usage

This isn't designed to be as fully featured as things like OptionParser and Trollop.
I just wanted to get at cli arguments without having to use a fully-featured DSL to specify
exactly what I needed.

It accepts a string array and returns a hash containing commands and options.

```ruby
Minimist.parse("parse this --with=2 -asbd -n4 --no-changes --send two".split(" "))

=> {
  :commands=>["parse", "this"],
  :options=> {
    :with=>"2",
    :a=>true,
    :s=>true,
    :b=>true,
    :d=>true,
    :n=>"4",
    :changes=>false,
    :send=>"two"
  }
}
```

## Contributing

Create a pr discussing your change and make sure to add a test for your feature :)

1. Fork it ( https://github.com/[my-github-username]/minimist/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
