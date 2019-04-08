# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed # This call allows the UI to have access to the various work types
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do |example|
    DatabaseCleaner.strategy = if example.metadata.key?(:with_named_js)
                                 :truncation
                               else
                                 :transaction
                               end
  end

  config.before do
    DatabaseCleaner.start
  end

  # This is horrendous, but JS tests don't work with the deletion strategy, so we must use truncation instead.
  # See https://github.com/DatabaseCleaner/database_cleaner#rspec-with-capybara-example
  config.after do |example|
    DatabaseCleaner.clean
    Rails.application.load_seed if example.metadata.key?(:with_named_js)
  end
end
