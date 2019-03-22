# frozen_string_literal: true

module RemoteAuthentication
  def sign_in(user = nil)
    driver = driver_name(user)
    Capybara.register_driver(driver) do |app|
      Capybara::RackTest::Driver.new(app,
                                     respect_data_method: true,
                                     headers: request_headers(user))
    end
    Capybara.current_driver = driver
  end

  private

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

    if example.metadata.key?(:with_psu_user)
      sign_in(create(:psu_user))
    else
      sign_in(create(:admin))
    end
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include RemoteAuthentication, type: :feature
end
