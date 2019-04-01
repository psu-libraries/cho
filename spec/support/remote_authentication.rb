# frozen_string_literal: true

require 'webdrivers'

module RemoteAuthentication
  def sign_in(user: nil, js_driver: nil)
    if js_driver
      sign_in_with_js(user: user, js_driver: js_driver)
    else
      sign_in_without_js(user)
    end
  end

  private

    def sign_in_without_js(user = nil)
      driver = driver_name(user)
      Capybara.register_driver(driver) do |app|
        Capybara::RackTest::Driver.new(app,
                                       respect_data_method: true,
                                       headers: request_headers(user))
      end
      Capybara.current_driver = driver
    end

    def sign_in_with_js(user:, js_driver:)
      unless Capybara.drivers.include?(js_driver)
        Capybara.register_driver js_driver do |app|
          capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: chrome_options)
          Capybara::Selenium::Driver.new(app,
                                           browser: :chrome,
                                           desired_capabilities: capabilities)
        end
      end
      Capybara.current_driver = js_driver

      login_as user
    end

    def driver_name(user = nil)
      if user
        "rack_test_authenticated_header_#{user.login}"
      else
        'rack_test_authenticated_header_anonymous'
      end
    end

    def request_headers(user = nil)
      return {} unless user

      { 'REMOTE_USER' => user.login }
    end

    def chrome_options
      { args: ['no-sandbox', 'headless', 'disable-gpu', 'window-size=1024,768', 'single-process'] }
    end
end

RSpec.configure do |config|
  config.before(type: :controller) do |example|
    next if example.metadata.key?(:with_public_user)

    request.headers['REMOTE_USER'] = if example.metadata.key?(:with_psu_user)
                                       create(:psu_user).login
                                     else
                                       create(:admin).login
                                     end
  end

  config.before(type: :feature) do |example|
    next if example.metadata.key?(:with_public_user)

    js_driver = example.metadata.fetch(:with_named_js, nil)

    if example.metadata.key?(:with_psu_user)
      sign_in(user: create(:psu_user), js_driver: js_driver)
    else
      sign_in(user: create(:admin), js_driver: js_driver)
    end
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature
  config.after(type: :feature) { Warden.test_reset! }
  config.include RemoteAuthentication, type: :feature
end
