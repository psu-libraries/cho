# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch::SelectController, type: :controller do
  describe '::prefixes' do
    its(:_prefixes) { is_expected.to eq(['application', 'batch', 'catalog']) }
  end

  describe 'GET #index' do
    it 'renders the catalog search page' do
      get :index
      expect(response).to be_success
    end
  end
end
