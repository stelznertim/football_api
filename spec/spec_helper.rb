# frozen_string_literal: true

ENV['ENV'] = ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'racklog'
require 'database_cleaner-sequel'
require 'faker'
require 'factory_bot'
require 'simplecov'
require 'super_diff/rspec'

SimpleCov.start do
  enable_coverage :branch
  primary_coverage :branch
  # add_filter %w[/lib/environment.rb]
end
SimpleCov.minimum_coverage line: 100, branch: 100
Racklog.logger.level = Logger::UNKNOWN

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    FactoryBot.define { to_create { |i| i.save } }
    FactoryBot.find_definitions
    FactoryBot::Evaluator.include RSpec::Mocks::ExampleMethods
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random

  config.around { |example| DatabaseCleaner.cleaning { example.run } }
end
