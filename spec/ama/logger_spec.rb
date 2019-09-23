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

  describe '.stringified_hash' do
    let(:base) { Logger.new(StringIO.new) }

    subject do
      described_class.stringified_hash(
        base,
        filters: [:password],
        event_name: 'test',
        progname: 'program'
      )
    end

    it 'returns a new Logger instance' do
      expect(subject.object_id).to_not eq(base.object_id)
      expect(subject).to be_a(Logger)
    end

    it 'sets the formatter as a StringifiedHash formatter' do
      expect(subject.formatter).to be_a(Ama::Logger::Formatter::StringifiedHash)
    end

    it 'sets the progname attribute' do
      expect(subject.progname).to eq('program')
    end
  end
end
