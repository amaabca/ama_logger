# frozen_string_literal: true

describe Ama::Logger do
  describe '.root' do
    it 'returns the root pathname to the gem' do
      expect(described_class.root).to be_a(Pathname)
    end
  end

  describe '.lambda' do
    it 'returns a new Logger instance' do
      expect(described_class.lambda).to be_a(Logger)
    end

    it 'accepts parameters' do
      logger = described_class.lambda(StringIO.new, progname: 'test', level: Logger::Severity::DEBUG)
      expect(logger.level).to eq(Logger::Severity::DEBUG)
    end
  end
end
