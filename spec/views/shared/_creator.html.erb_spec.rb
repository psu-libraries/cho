# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/input_partials/creator', type: :view do
  let!(:agent1) { create :agent, given_name: 'Jane', surname: 'Doe' }
  let!(:agent2) { create :agent }
  let(:field) { instance_double Schema::InputField, options: {}, label: 'creator' }

  before do
    allow(field).to receive(:datalist).with(component: :roles).and_return(MockRDF.relators)
    allow(field).to receive(:datalist).with(component: :agents).and_return([agent1, agent2])
    allow(field).to receive(:values).and_return([creator_hash])
    view.form_for(resource, url: 'blah') do |form|
      render 'shared/input_partials/creator', form: form, field: field
    end
  end

  context 'with a work' do
    let(:resource) { build :work }

    context 'without roles or agents' do
      let(:creator_hash) { {} }

      it_behaves_like 'a creator form'
    end

    context 'with a role and agent' do
      let(:creator_hash) { { role: MockRDF.relators.first.to_uri.to_s, agent: agent1.id } }

      it_behaves_like 'a creator form'
    end
  end

  context 'with an archival collection' do
    let(:resource) { build :archival_collection }

    context 'without roles or agents' do
      let(:creator_hash) { {} }

      it_behaves_like 'a creator form'
    end

    context 'with a role and agent' do
      let(:creator_hash) { { role: MockRDF.relators.first.to_uri.to_s, agent: agent1.id } }

      it_behaves_like 'a creator form'
    end
  end

  context 'with an library collection' do
    let(:resource) { build :library_collection }

    context 'without roles or agents' do
      let(:creator_hash) { {} }

      it_behaves_like 'a creator form'
    end

    context 'with a role and agent' do
      let(:creator_hash) { { role: MockRDF.relators.first.to_uri.to_s, agent: agent1.id } }

      it_behaves_like 'a creator form'
    end
  end

  context 'with an curated collection' do
    let(:resource) { build :curated_collection }

    context 'without roles or agents' do
      let(:creator_hash) { {} }

      it_behaves_like 'a creator form'
    end

    context 'with a role and agent' do
      let(:creator_hash) { { role: MockRDF.relators.first.to_uri.to_s, agent: agent1.id } }

      it_behaves_like 'a creator form'
    end
  end
end
