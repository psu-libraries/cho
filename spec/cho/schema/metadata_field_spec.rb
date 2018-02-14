# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::MetadataField, type: :model do
  subject { model }

  let(:resource_klass) { described_class }
  let(:model) { build :schema_metadata_field,
                      label: 'abc123_label', field_type: 'date',
                      requirement_designation: 'recommended',
                      controlled_vocabulary: 'no_vocabulary',
                      default_value: 'abc123',
                      display_name: 'My Abc123',
                      display_transformation: 'no_transformation',
                      multiple: false, validation: 'no_validation',
                      core_field: false, order_index: 0 }

  it_behaves_like 'a Valkyrie::Resource'

  it { is_expected.to respond_to(:label) }
  it { is_expected.to respond_to(:multiple) }
  it { is_expected.to respond_to(:field_type) }
  it { is_expected.to respond_to(:requirement_designation) }
  it { is_expected.to respond_to(:controlled_vocabulary) }
  it { is_expected.to respond_to(:default_value) }
  it { is_expected.to respond_to(:display_name) }
  it { is_expected.to respond_to(:display_transformation) }
  it { is_expected.to respond_to(:help_text) }
  it { is_expected.to respond_to(:index_type) }
  it { is_expected.to respond_to(:order_index) }

  context 'when saving with metadata' do
    subject { saved_model }

    let(:saved_model) { Valkyrie.config.metadata_adapter.persister.save(resource: model) }
    let(:expected_metadata) { { controlled_vocabulary: 'no_vocabulary',
                                created_at: saved_model.created_at,
                                default_value: 'abc123',
                                display_name: 'My Abc123',
                                display_transformation: 'no_transformation',
                                field_type: 'date',
                                help_text: 'help me',
                                id: saved_model.id,
                                index_type: 'no_facet',
                                internal_resource: 'Schema::MetadataField',
                                label: 'abc123_label',
                                multiple: false,
                                requirement_designation: 'recommended',
                                updated_at: saved_model.updated_at,
                                validation: 'no_validation',
                                core_field: false,
                                order_index: 0 } }

    its(:attributes) { is_expected.to eq(expected_metadata) }
  end
end
