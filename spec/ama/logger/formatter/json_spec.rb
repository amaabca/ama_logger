# frozen_string_literal: true

describe Ama::Logger::Formatter::Json do
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
      context 'without the :event_name parameter' do
        it 'raises ArgumentError' do
          expect { subject.call('INFO', time, nil, event_id: '1', event_source: 'test') }.to raise_error(
            ArgumentError,
            /must pass the `event_name` argument/
          )
        end
      end

      context 'without the :event_id parameter' do
        it 'raises ArgumentError' do
          expect { subject.call('INFO', time, nil, event_name: 'test', event_source: 'test') }.to raise_error(
            ArgumentError,
            /must pass the `event_id` argument/
          )
        end
      end

      context 'without the :event_source parameter' do
        it 'raises ArgumentError' do
          expect { subject.call('INFO', time, nil, event_name: 'test', event_id: '1') }.to raise_error(
            ArgumentError,
            /must pass the `event_source` argument/
          )
        end
      end

      context 'with valid parameters' do
        let(:msg) do
          {
            event_name: 'log.info',
            event_id: '1',
            event_source: 'test',
            exception: 'FakeError: something failed',
            execution_time_ms: 12_340,
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

        it 'includes the execution time' do
          expect(parsed['executionTime']).to eq(12_340)
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
