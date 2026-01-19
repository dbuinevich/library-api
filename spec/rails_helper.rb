# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Abort if the Rails environment is running in production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'factory_bot_rails'
require 'database_cleaner/active_record'
require 'shoulda/matchers'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Maintain test schema
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # FactoryBot syntax
  config.include FactoryBot::Syntax::Methods

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # DatabaseCleaner setup (optional but works well with jobs & mailers)
  config.before(:suite) do
    # Allow cleaning databases that look "remote" (safe in tests)
    DatabaseCleaner.allow_remote_database_url = true

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # RSpec Rails behaviors
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = "tmp/rspec_failures.txt"

  # Include ActiveJob test helpers
  config.include ActiveJob::TestHelper

  # Include ActionMailer test helpers
  config.include ActionMailer::TestHelper

  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  config.after(:each) do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

