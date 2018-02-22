# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  before(:all) do
    # Create a fake controller for our tests
    class ExamplesController < ApplicationController
      def index
        render body: nil
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

  subject { response }

  describe 'GET' do
    before { get examples_path, headers: headers }

    context 'with a public user' do
      let(:headers) { {} }

      it { is_expected.to have_http_status(:unauthorized) }
      its(:body) { is_expected.to eq('<h1>Unauthorized</h1><p>Please <a href="/devise_remote/login">login</a></p>') }
    end

    context 'with an authenticated user' do
      let(:headers) { { 'REMOTE_USER' => 'user' } }

      it { is_expected.to be_success }
    end
  end
end
