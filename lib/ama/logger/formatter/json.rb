# frozen_string_literal: true

module Ama
  module Logger
    module Formatter
      class Json
        def call(severity, time, _progname, msg = {})
          invalid_argument!(:msg, Hash, msg) unless msg.is_a?(Hash)

          event_name = msg.fetch(:event_name) { missing_argument!(:event_name) }
          event_source = msg.fetch(:event_source) { missing_argument!(:event_source) }
          event_id = msg.fetch(:event_id) { missing_argument!(:event_id) }
          execution_time = msg.fetch(:execution_time)

          {
            exception: msg[:exception],
            eventName: event_name,
            eventSource: event_source.to_s,
            eventId: event_id.to_s,
            eventAgent: Ama::Logger::AGENT_VERSION,
            executionTime: execution_time,
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
