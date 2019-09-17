# frozen_string_literal: true

require_relative 'logger/base'

module Ama
  # global logger instance initialization
  # usage:
  #
  # Ama.logger.info(context: context, event_name: 'test')
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.lambda
    end
  end

  module Logger
    AGENT_VERSION = "ama_logger:#{Ama::Logger::VERSION}"

    class << self
      def root
        Pathname.new(Gem.loaded_specs['ama_logger'].full_gem_path)
      end

      def lambda(io = STDOUT, *args)
        ::Logger.new(io, *args).tap do |instance|
          instance.formatter = Ama::Logger::Formatter::Lambda.new
        end
      end
    end
  end
end
