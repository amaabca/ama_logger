# frozen_string_literal: true

module Ama
  module Logger
    module Formatter
      class Lambda
        def call(severity, time, _progname, msg = {})
          invalid_argument!(:msg, Hash, msg) unless msg.is_a?(Hash)

          context = msg.fetch(:context) { missing_argument!(:context) }
          event_name = msg.fetch(:event_name) { missing_argument!(:event_name) }

          {
            exception: msg[:exception],
            eventName: event_name,
            eventSource: context.invoked_function_arn,
            eventId: context.aws_request_id,
            eventAgent: Ama::Logger::AGENT_VERSION,
            details: details(msg),
            indexed: indexed(msg),
            severity: severity,
            timestamp: time.utc.iso8601
          }
            .compact
            .to_json
            .concat("\n")
        end

        private

        def details(data = {})
          data.fetch(:details) { {} }.to_json
        end

        def indexed(opts = {})
          data = opts.slice(:metric_name, :metric_value, :metric_content)

          {
            metricName: data[:metric_name]&.to_s,
            metricValue: data[:metric_value]&.to_i,
            metricContent: data[:metric_content]&.to_s
          }
            .compact
        end

        def missing_argument!(name)
          raise ArgumentError, "must pass the `#{name}` argument"
        end

        def invalid_argument!(name, klass, value)
          raise ArgumentError, "expected type `#{klass.inspect}` for argument `#{name}` - got `#{value.inspect}`"
        end
      end
    end
  end
end
