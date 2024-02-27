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

## Formatters

This library includes the following custom log formatters:

### Ama::Logger::Formatter::Lambda

This formatter accepts a Ruby hash as a message, an AWS Lambda context instance and outputs a JSON string.

The input hash must look like:

```ruby
Ama.logger.info(
  context: context,                             # required - the Lambda context instance (https://docs.aws.amazon.com/lambda/latest/dg/ruby-context.html)
  event_name: 'log.info',                       # required
  exception: 'ArgumentError - something broke', # optional - indexed
  metric_name: 'error:count',                   # optional - indexed
  metric_value: 1,                              # optional - indexed, coerced to integer
  metric_content: 'error',                      # optional - indexed, coerced to string
  details: { message: 'test' }                  # optional - non-indexed, Hash coerced to string
)
```

### Ama::Logger::Formatter::Json

This formatter accepts a Ruby hash as a message and outputs a JSON string.

The input hash must look like:

```ruby
Ama.logger.info(
  event_name: 'log.info',                       # required
  event_id: '1234',                             # required - indexed
  event_source: 'my_source',                    # required - indexed
  exception: 'ArgumentError - something broke', # optional - indexed
  execution_time_ms: 1234.56,                   # optional - indexed
  metric_name: 'error:count',                   # optional - indexed
  metric_value: 1,                              # optional - indexed, coerced to integer
  metric_content: 'error',                      # optional - indexed, coerced to string
  details: { message: 'test' }                  # optional - non-indexed, Hash coerced to string
)
```

### Ama::Logger::Formatter::StringifiedHash

This formatter accepts string message and outputs a JSON string. The formatter is able to filter sensitive data based on the input provided.

Instances of this formatter accept the following parameters during initialization:

```ruby
Ama::Logger::Formatter::StringifiedHash.new(
  filters: [:password],  # optional - named parameters that will be filtered from output
  event_name: 'my.event' # optional - mapped to the `eventName` property in JSON output
)
```

This formatter is commonly used to filter sensitive data from internal Rails logging mechanisms (i.e. ActiveJob).

See below for an example to override the ActiveJob logger:

```ruby
ActiveJob::Base.logger = Ama::Logger.stringified_hash(
  ActiveJob::Base.logger,
  event_name: 'rails.activejob',
  filters: Rails.configuration.filter_parameters,
  progname: 'gatekeeper'
)
```

### Mixins

#### Ama::Logger::Mixins::LambdaHandler

Defines a method that accepts the `event:` and `context:` named arguments as used in an AWS lambda function and logs the input event and output response.

```ruby
class MyClass
  extend Ama::Logger::Mixins::LambdaHandler

  define_lambda_handler(:handler) do |event, context|
    # do something
  end
end

MyClass.handle(event: event, context: context) # => the output of lambda handler
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amaabca/ama_logger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
