# frozen_string_literal: true

module WebdriverHelpers
  def retry_click(count: 0)
    count = count + 1
    yield
  rescue Selenium::WebDriver::Error::WebDriverError => e
    retry if count < 20
    raise e
  end
end

RSpec.configure do |config|
  config.include WebdriverHelpers, type: :feature
  Webdrivers.logger.level = :debug
end
