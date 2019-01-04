# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch::DeleteController, type: :controller do
  describe '::prefixes' do
    its(:_prefixes) { is_expected.to eq(['batch/delete', 'application', 'batch']) }
  end

  describe 'POST #confirm' do
    let(:work)       { create(:work) }
    let(:collection) { create(:archival_collection) }

    it 'lists the items we want to delete' do
      post :confirm, params: { delete: { ids: [work.to_param, collection.to_param] } }
      expect(response).to be_success
    end
  end

  describe 'DELETE #destroy' do
    let(:metadata_adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }
    let!(:work)       { create(:work) }
    let!(:collection) { create(:archival_collection) }

    it 'destroys the requested resources' do
      expect {
        delete :destroy, params: { delete: { ids: [work.to_param, collection.to_param] } }
      }.to change { metadata_adapter.query_service.find_all.to_a.count }.by(-2)
      expect(flash[:success]).to eq(
        I18n.t('cho.batch.delete.success', list: 'Sample Generic Work (0 items), Archival Collection (0 items)')
      )
    end
  end
end
