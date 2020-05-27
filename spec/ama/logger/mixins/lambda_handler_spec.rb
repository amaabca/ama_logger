# frozen_string_literal: true

describe Ama::Logger::Mixins::LambdaHandler do
  let(:klass) { Class.new }
  let(:context) { build(:context) }
  subject { klass.extend(described_class) }

  describe '#define_lambda_handler' do
    before(:each) do
      subject.define_lambda_handler(:handler) { |_e, _v| { output: true } }
    end

    it 'defines a method that matches the name argument' do
      expect(subject).to respond_to(:handler)
    end

    it 'defines a lambda handler that logs the input event and output response' do
      expect(Ama.logger).to receive(:info)
        .twice
        .and_call_original
      subject.handler(event: { test: true }, context: context)
    end

    it 'defines a handler that logs raised StandardError instances' do
      content = ['1', context.invoked_function_arn].join(':')

      # first the input event is logged
      expect(Ama.logger).to receive(:info)
        .with(
          context: context,
          event_name: 'log.info',
          metric_name: 'lambda.input',
          metric_content: '{"id":"1"}'
        )
        .once
        .and_call_original

      # then the error is logged
      expect(Ama.logger).to receive(:info)
        .with(
          context: context,
          event_name: 'log.error',
          metric_name: 'lambda.error',
          metric_content: content,
          exception: instance_of(StandardError)
        )
        .once
        .and_call_original

      # define a handler that raises an error
      subject.define_lambda_handler(:raise!) do |event, context|
        raise StandardError, "#{event['id']}:#{context.invoked_function_arn}"
      end

      expect { subject.raise!(event: { 'id' => '1' }, context: context) }.to raise_error(
        StandardError,
        content
      )
    end
  end
end
