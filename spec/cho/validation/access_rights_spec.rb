# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::AccessRights do
  describe '#validate' do
    subject { validation_instance.validate(access_level) }

    let(:validation_instance) { described_class.new }

    context 'with a valid access level' do
      let(:access_level) { Repository::AccessLevel.public }

      it 'is valid' do
        expect(validation_instance.validate(access_level)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with an invalid access level' do
      let(:access_level) { 'bogus' }

      it 'is not valid' do
        expect(validation_instance.validate(access_level)).to be_falsey
        expect(validation_instance.errors).to contain_exactly('bogus is not a valid access right')
      end
    end

    context 'with a null access level' do
      let(:access_level) { nil }

      it 'is valid' do
        expect(validation_instance.validate(access_level)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end
  end
end
