[![Ruby](https://github.com/mmcs-ruby/qar/actions/workflows/main.yml/badge.svg)](https://github.com/mmcs-ruby/qar/actions/workflows/main.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4b94e2d823470345913/maintainability)](https://codeclimate.com/github/mmcs-ruby/qar/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d4b94e2d823470345913/test_coverage)](https://codeclimate.com/github/mmcs-ruby/qar/test_coverage)

# Qar

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/qar`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qar'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install qar

## Usage

### Qbit

To create a qubit with given probability amplitudes:

    q0 = Qbit.new(1, 0)  # |0>
    q1 = Qbit.new(0, 1)  # |1>
    
with random probability amplitudes:

    q = Qbit.generate 
        # a|0> + b|1>

To measure:

    q.measure

### Entanglement

Entanglements are the result of gates, but you can create them manually as well:

    e = Entanglement(q0, q1, Qbit.generate) # a|010> + b|011>

Also you can add some qubits to a specific entanglement:

    e.push!(Qbit.new(Math.sqrt(0.5), Math.sqrt(0.5))) 
        # 1/√2(a|0100> + b|0110> + a|0101> + b|0111>)

    e2 = e.unshift(q0)
        # 1/√2(a|00100> + b|00110> + a|00101> + b|00111>)

To measure:

    e.measure!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/qar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/qar/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Qar project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/qar/blob/master/CODE_OF_CONDUCT.md).
