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

    context 'as a private user', with_user: :private_user do
      let(:private_user) { build(:user) }

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

      context 'with a restricted collection' do
        let(:document) { create(:restricted_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted library collection' do
        let(:document) { create(:restricted_library_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted curated collection' do
        let(:document) { create(:restricted_curated_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted work' do
        let(:document) { create(:work, :restricted) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted file set' do
        let(:document) { create(:file_set, :restricted) }

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

      context 'with a restricted collection' do
        let(:document) { create(:restricted_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted library collection' do
        let(:document) { create(:restricted_library_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted curated collection' do
        let(:document) { create(:restricted_curated_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted work' do
        let(:document) { create(:work, :restricted) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted file set' do
        let(:document) { create(:file_set, :restricted) }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    context 'as a private user', with_user: :private_user do
      let(:private_user) { build(:user) }

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

      context 'with a restricted collection' do
        let(:document) { create(:restricted_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted library collection' do
        let(:document) { create(:restricted_library_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted curated collection' do
        let(:document) { create(:restricted_curated_collection) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted work' do
        let(:document) { create(:work, :restricted) }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with a restricted file set' do
        let(:document) { create(:file_set, :restricted) }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    context 'as a private creator', with_user: :private_creator do
      let(:private_creator) { build(:user) }

      context 'with a public collection' do
        let(:document) do
          create(:public_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a public library collection' do
        let(:document) do
          create(:public_library_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a public curated collection' do
        let(:document) do
          create(:public_curated_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a public work' do
        let(:document) do
          create(:public_work, system_creator: private_creator.login, read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a public file set' do
        let(:document) do
          create(:file_set, system_creator: private_creator.login, read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a Penn State collection' do
        let(:document) do
          create(:psu_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a Penn State library collection' do
        let(:document) do
          create(:psu_library_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a Penn State curated collection' do
        let(:document) do
          create(:psu_curated_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a Penn State work' do
        let(:document) do
          create(:work, :restricted_to_penn_state,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a Penn State file set' do
        let(:document) do
          create(:file_set, :restricted_to_penn_state,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a restricted collection' do
        let(:document) do
          create(:restricted_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a restricted library collection' do
        let(:document) do
          create(:restricted_library_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a restricted curated collection' do
        let(:document) do
          create(:restricted_curated_collection,
                 system_creator: private_creator.login,
                 read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a restricted work' do
        let(:document) do
          create(:work, :restricted, system_creator: private_creator.login, read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end

      context 'with a restricted file set' do
        let(:document) do
          create(:file_set, :restricted, system_creator: private_creator.login, read_users: [private_creator.login])
        end

        it { is_expected.to be_success }
      end
    end

    context 'as a private group member', with_user: :private_group_member do
      let(:private_group_member) { create(:user, :in_private_group) }

      context 'with read access to a restricted collection' do
        let(:document) { create(:restricted_collection, read_groups: ['private_group']) }

        it { is_expected.to be_success }
      end

      context 'with read access a restricted library collection' do
        let(:document) { create(:restricted_library_collection, read_groups: ['private_group']) }

        it { is_expected.to be_success }
      end

      context 'with read access a restricted curated collection' do
        let(:document) { create(:restricted_curated_collection, read_groups: ['private_group']) }

        it { is_expected.to be_success }
      end

      context 'with read access a restricted work' do
        let(:document) { create(:work, :restricted, read_groups: ['private_group']) }

        it { is_expected.to be_success }
      end

      context 'with read access a restricted file set' do
        let(:document) { create(:file_set, :restricted, read_groups: ['private_group']) }

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

      context 'with a restricted collection' do
        let(:document) { create(:restricted_collection) }

        it { is_expected.to be_success }
      end

      context 'with a restricted library collection' do
        let(:document) { create(:restricted_library_collection) }

        it { is_expected.to be_success }
      end

      context 'with a restricted curated collection' do
        let(:document) { create(:restricted_curated_collection) }

        it { is_expected.to be_success }
      end

      context 'with a restricted work' do
        let(:document) { create(:work, :restricted) }

        it { is_expected.to be_success }
      end

      context 'with a restricted file set' do
        let(:document) { create(:file_set, :restricted) }

        it { is_expected.to be_success }
      end
    end
  end
end
