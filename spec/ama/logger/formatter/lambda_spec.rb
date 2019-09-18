# frozen_string_literal: true

describe Ama::Logger::Formatter::Lambda do
  describe '#call' do
    let(:time) { Time.now }

    context 'when called with a string `msg` parameter' do
      it 'raises ArgumentError' do
        expect { subject.call('INFO', time, nil, 'test') }.to raise_error(
          ArgumentError,
          /expected type `Hash`/
        )
      end
    end

    context 'when called with a Hash `msg` parameter' do
      context 'without providing a :context value' do
        it 'raises ArgumentError' do
          expect { subject.call('INFO', time, nil, {}) }.to raise_error(
            ArgumentError,
            /must pass the `context` argument/
          )
        end
      end

      context 'with the :context parameter' do
        let(:context) { FactoryBot.build(:context) }

        context 'without the :event_name parameter' do
          it 'raises ArgumentError' do
            expect { subject.call('INFO', time, nil, context: context) }.to raise_error(
              ArgumentError,
              /must pass the `event_name` argument/
            )
          end
        end

        context 'with the :event_name parameter' do
          let(:msg) do
            {
              context: context,
              event_name: 'log.info',
              exception: 'FakeError: something failed',
              metric_name: 'error_count',
              metric_value: '1',
              metric_content: 'test@example.com',
              details: {
                errors: ['there was a problem']
              }
            }
          end
          let(:entry) { subject.call('INFO', time, nil, msg) }
          let(:parsed) { JSON.parse(entry) }

          it 'returns a string' do
            expect(entry).to be_a(String)
          end

          it 'has a trailing newline' do
            expect(entry[-1]).to eq("\n")
          end

          it 'includes the event name' do
            expect(parsed['eventName']).to eq('log.info')
          end

          it 'includes the exception message' do
            expect(parsed['exception']).to include('FakeError')
          end

          it 'includes the severity' do
            expect(parsed['severity']).to eq('INFO')
          end

          it 'includes the indexed metrics' do
            expect(parsed.dig('indexed', 'metricName')).to eq('error_count')
            expect(parsed.dig('indexed', 'metricValue')).to eq(1)
            expect(parsed.dig('indexed', 'metricContent')).to eq('test@example.com')
          end

          it 'stringifies the details Hash' do
            expect(parsed['details']).to eq('{"errors":["there was a problem"]}')
          end
        end
      end
    end
  end
end
