# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviseRemote do
  describe '::web_access_url' do
    its(:web_access_url) { is_expected.to eq('https://webaccess.psu.edu/?cosign-example-test') }
  end

  describe '::new_session_redirect_url' do
    its(:new_session_redirect_url) { is_expected.to eq('http://test.com/') }
  end

  describe '::destroy_redirect_url' do
    its(:destroy_redirect_url) { is_expected.to eq('https://webaccess.psu.edu/cgi-bin/logout?http://test.com/') }
  end
end
