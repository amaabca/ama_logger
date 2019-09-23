# frozen_string_literal: true

describe Ama::Logger::Formatter::StringifiedHash do
  subject do
    described_class.new(
      filters: %i[
        access_token
        password
      ],
      event_name: 'rails.activejob'
    )
  end

  describe '#call' do
    let(:message) do
      'Enqueued DeleteApiHouseholdCacheJob ' \
        '(Job ID: f454e3dd-9d34-496a-a0e2-aee5e69f3025) to ' \
        'Shoryuken(gatekeeper-sqs-dev-Queue-123) with arguments: ' \
        '{:access_token=>"1111-111-111-1111",:id=>"1234",:password=>"secr3t"}'
    end
    let(:sanitized) do
      'Enqueued DeleteApiHouseholdCacheJob ' \
        '(Job ID: f454e3dd-9d34-496a-a0e2-aee5e69f3025) to ' \
        'Shoryuken(gatekeeper-sqs-dev-Queue-123) with arguments: ' \
        '{:access_token=>"[FILTERED]",:id=>"1234",:password=>"[FILTERED]"}'
    end
    let(:payload) { subject.call('INFO', Time.now, nil, message) }
    let(:data) { JSON.parse(payload) }

    it 'filters out sensitive parameters from strings' do
      expect(data['details']).to eq(sanitized)
    end

    it 'includes the specified event name' do
      expect(payload).to include('rails.activejob')
    end
  end
end
