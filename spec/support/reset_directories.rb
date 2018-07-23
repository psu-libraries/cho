# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    Metrics::Repository.reset_directories
  end
end
