# frozen_string_literal: true

describe Ama do
  describe '.logger' do
    it 'returns a Logger instance' do
      expect(described_class.logger).to be_a(Logger)
    end
  end
end
