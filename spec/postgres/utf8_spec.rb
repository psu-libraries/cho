# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Valkyrie::Resource, type: :model do
  before do
    class UtfModel < Valkyrie::Resource
      attribute :random_string
    end
  end

  after do
    ActiveSupport::Dependencies.remove_constant('UtfModel')
  end

  let(:valid_characters) { Faker::String.random(1_000).tr(bad_characters, '') }
  let(:invalid_characters) { Faker::String.random(1_000) + bad_characters }
  let(:bad_characters) { 0o000.chr(Encoding::UTF_8) }

  it 'accepts all valid UTF-8 characters, except for the ones we know it does not' do
    resource = UtfModel.new(random_string: valid_characters)
    updated_resource = Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    expect(updated_resource.random_string).to contain_exactly(valid_characters)
  end

  it 'raises an error when there are bad UTF characters' do
    resource = UtfModel.new(random_string: invalid_characters)
    expect {
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
