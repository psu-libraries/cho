# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Agent::Resource, type: :model do
  subject { model }

  let(:resource_klass) { described_class }
  let(:model) { build :agent,
                      given_name: 'sally',
                      surname: 'brown' }

  it_behaves_like 'a Valkyrie::Resource'

  it { is_expected.to respond_to(:given_name) }
  it { is_expected.to respond_to(:surname) }

  context 'when saving with metadata' do
    subject { saved_model }

    let(:saved_model) { Valkyrie.config.metadata_adapter.persister.save(resource: model) }
    let(:expected_metadata) { { given_name: 'sally',
                                created_at: saved_model.created_at,
                                internal_resource: 'Agent::Resource',
                                new_record: false,
                                surname: 'brown',
                                id: saved_model.id,
                                updated_at: saved_model.updated_at } }

    its(:attributes) { is_expected.to eq(expected_metadata) }
  end
end
