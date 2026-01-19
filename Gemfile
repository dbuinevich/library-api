source "https://rubygems.org"

# CORE
gem "rails", "~> 8.1.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# API helpers
gem "active_model_serializers", "~> 0.10.16"
gem "sidekiq"

# CORS support
gem "rack-cors"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem 'database_cleaner-active_record'
  gem 'pry-rails'
end

group :development do
  gem "letter_opener"
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
end
