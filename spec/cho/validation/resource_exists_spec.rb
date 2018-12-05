# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::ResourceExists, type: :model do
  describe '#validate' do
    let(:validator) { described_class.new }

    context 'with an id' do
      let(:collection) { create(:archival_collection) }

      it 'is valid' do
        expect(validator.validate(collection.id)).to be_truthy
        expect(validator.errors).to be_empty
      end
    end

    context 'with neither a non-existent id' do
      it 'is not valid' do
        expect(validator.validate('non_existing')).to be_falsey
        expect(validator.errors).to eq(['non_existing does not exist'])
      end
    end
  end
end
