# frozen_string_literal: true

module Ama
  module Logger
    module Formatter
      class StringifiedHash
        attr_accessor :filters, :regex, :event_name

        def initialize(opts = {})
          self.filters = opts.fetch(:filters) { [] }
                             .select { |p| p.is_a?(Symbol) || p.is_a?(String) }
                             .map(&:to_s)
                             .join('|')
          self.regex = /:(?<name>#{filters})=>"(?<value>[^"]*)"/
          self.event_name = opts.fetch(:event_name) { 'log.rails' }
        end

        def call(severity, time, progname, msg)
          {
            eventName: event_name,
            eventSource: progname || self.class.name,
            eventId: SecureRandom.uuid,
            eventAgent: Ama::Logger::AGENT_VERSION,
            severity: severity,
            details: msg.gsub(regex, ':\k<name>=>"[FILTERED]"'),
            timestamp: time.utc.iso8601
          }
            .compact
            .to_json
            .concat("\n")
        end
      end
    end
  end
end
