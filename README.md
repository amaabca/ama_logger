# Ama::Logger

This library implements AMA's standardized log format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ama_logger', git: 'git@github.com:amaabca/ama_logger'
```

## Usage

A default logger instance that writes to `STDOUT` is provided via the `Ama.logger` method:

```ruby
Ama.logger.info(context: context, event_name: 'log.info', metric_name: 'test', metric_value: 1)
```

You can override the default logger instance if you wish:

```ruby
Ama.logger = Ama::Logger.lambda(STDERR, level: Logger::Severity::DEBUG)
```

The default `logger` instance is intended for use with AWS Lambda - it requires a `context` instance (from a [Lambda handler](https://docs.aws.amazon.com/lambda/latest/dg/ruby-context.html)) to be passed as well as any additional data.

Instead of passing a log string, you must pass a `Hash` of data:

```ruby
Ama.logger.info(
  context: context,                             # required - the Lambda context instance
  event_name: 'log.info',                       # required
  exception: 'ArgumentError - something broke', # optional - indexed
  metric_name: 'error:count',                   # optional - indexed
  metric_value: 1,                              # optional - indexed, coerced to integer
  metric_content: 'error',                      # optional - indexed, coerced to string
  details: { message: 'test' }                  # optional - non-indexed, Hash coerced to string
)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amaabca/ama_logger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
