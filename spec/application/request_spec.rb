# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  subject { response }

  before(:all) do
    # Create a fake controller for our tests
    class ExamplesController < ApplicationController
      def index
        render body: 'Hooray!'
      end

      def edit
        render body: 'Hooray!'
      end
    end

    Rails.application.routes.draw do
      resources :examples
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('ExamplesController')
    Rails.application.reload_routes!
  end

  describe 'GET index' do
    before { get examples_path, headers: headers }

    context 'with a public user' do
      let(:headers) { {} }

      it { is_expected.to have_http_status(:unauthorized) }
      its(:body) { is_expected.to eq('<h1>Unauthorized</h1><p>Please <a href="/devise_remote/login">login</a></p>') }
    end

    context 'with an authenticated non-admin user' do
      let(:user) { create(:psu_user) }
      let(:headers) { { 'REMOTE_USER' => user.login } }

      it { is_expected.to have_http_status(:success) }
      its(:body) { is_expected.to eq('Hooray!') }
    end

    context 'with an authenticated admin user' do
      let(:admin) { create(:admin) }
      let(:headers) { { 'REMOTE_USER' => admin.login } }

      it { is_expected.to have_http_status(:success) }
      its(:body) { is_expected.to eq('Hooray!') }
    end
  end

  describe 'GET edit' do
    before { get edit_example_path(1), headers: headers }

    context 'with a public user' do
      let(:headers) { {} }

      before { request }

      it { is_expected.to have_http_status(:unauthorized) }
      its(:body) { is_expected.to eq('<h1>Unauthorized</h1><p>Please <a href="/devise_remote/login">login</a></p>') }
    end

    context 'with an authenticated non-admin user' do
      let(:user) { create(:psu_user) }
      let(:headers) { { 'REMOTE_USER' => user.login } }

      it { is_expected.to have_http_status(:forbidden) }
      its(:body) { is_expected.to match(/You are not allowed to access this page/) }
    end

    context 'with an authenticated admin user' do
      let(:admin) { create(:admin) }
      let(:headers) { { 'REMOTE_USER' => admin.login } }

      before { request }

      it { is_expected.to have_http_status(:success) }
      its(:body) { is_expected.to eq('Hooray!') }
    end
  end
end
