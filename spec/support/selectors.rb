# frozen_string_literal: true

module Selectors
  def current_user
    find('#dropdownMenuButton').text
  rescue Capybara::ElementNotFound
    nil
  end
end

RSpec.configure do |config|
  config.include Selectors, type: :feature
end
