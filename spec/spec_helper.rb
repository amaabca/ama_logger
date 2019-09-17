# frozen_string_literal: true

require 'simplecov'
require 'bundler/setup'
require 'ama/logger'
require 'ostruct'
require 'factory_bot'
require 'rspec'
require 'pry'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
Ama.logger = Ama::Logger.lambda(StringIO.new)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
