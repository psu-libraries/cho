# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::ResourcesController, type: :controller do
  describe '::prefixes' do
    its(:_prefixes) { is_expected.to eq(['application', 'collection/resources', 'catalog']) }
  end

  describe 'GET #index' do
    it "renders the collection's browse page" do
      get :index, params: { archival_collection_id: '1' }
      expect(response).to be_success
    end
  end
end
