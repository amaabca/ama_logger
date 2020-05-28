# frozen_string_literal: true

module Ama
  module Logger
    module Mixins
      module LambdaHandler
        def define_lambda_handler(name)
          define_singleton_method(name) do |event:, context:|
            Ama.logger.info(
              context: context,
              event_name: 'log.info',
              metric_name: 'lambda.input',
              metric_content: event.to_json
            )
            yield(event, context).tap do |response|
              Ama.logger.info(
                context: context,
                event_name: 'log.info',
                metric_name: 'lambda.output',
                metric_content: response.to_json
              )
            end
          rescue StandardError => e
            Ama.logger.info(
              context: context,
              event_name: 'log.error',
              metric_name: 'lambda.error',
              metric_content: e.message,
              exception: e
            )
            raise
          end
        end
      end
    end
  end
end
