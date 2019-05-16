# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatalogController, type: :controller do
  subject { response }

  describe 'GET #index' do
    before { get :index }

    context 'as a public user', :with_public_user do
      it { is_expected.to be_success }
    end

    context 'as a Penn State user', :with_psu_user do
      it { is_expected.to be_success }
    end

    context 'as an admin user' do
      it { is_expected.to be_success }
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: document.id } }

    context 'as a public user', :with_public_user do
      context 'with a public collection' do
        let(:document) { create(:public_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public library collection' do
        let(:document) { create(:public_library_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public curated collection' do
        let(:document) { create(:public_curated_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public work' do
        let(:document) { create(:public_work) }

        it { is_expected.to be_success }
      end

      context 'with a public file set' do
        let(:document) { create(:file_set) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State collection' do
        let(:document) { create(:psu_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a Penn State library collection' do
        let(:document) { create(:psu_library_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a Penn State curated collection' do
        let(:document) { create(:psu_curated_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a Penn State work' do
        let(:document) { create(:work, :restricted_to_penn_state) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a Penn State file set' do
        let(:document) { create(:file_set, :restricted_to_penn_state) }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    context 'as a Penn State user', :with_psu_user do
      context 'with a public collection' do
        let(:document) { create(:public_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public library collection' do
        let(:document) { create(:public_library_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public curated collection' do
        let(:document) { create(:public_curated_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public work' do
        let(:document) { create(:public_work) }

        it { is_expected.to be_success }
      end

      context 'with a public file set' do
        let(:document) { create(:file_set) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State collection' do
        let(:document) { create(:psu_collection) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State library collection' do
        let(:document) { create(:psu_library_collection) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State curated collection' do
        let(:document) { create(:psu_curated_collection) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State work' do
        let(:document) { create(:work, :restricted_to_penn_state) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State file set' do
        let(:document) { create(:file_set, :restricted_to_penn_state) }

        it { is_expected.to be_success }
      end
    end

    context 'as an admin user' do
      context 'with a public collection' do
        let(:document) { create(:public_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public library collection' do
        let(:document) { create(:public_library_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public curated collection' do
        let(:document) { create(:public_curated_collection) }

        it { is_expected.to be_success }
      end

      context 'with a public work' do
        let(:document) { create(:public_work) }

        it { is_expected.to be_success }
      end

      context 'with a public file set' do
        let(:document) { create(:file_set) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State collection' do
        let(:document) { create(:psu_collection) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State library collection' do
        let(:document) { create(:psu_library_collection) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State curated collection' do
        let(:document) { create(:psu_curated_collection) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State work' do
        let(:document) { create(:work, :restricted_to_penn_state) }

        it { is_expected.to be_success }
      end

      context 'with a Penn State file set' do
        let(:document) { create(:file_set, :restricted_to_penn_state) }

        it { is_expected.to be_success }
      end
    end
  end
end
