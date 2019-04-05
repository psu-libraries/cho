# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::CharacterEncoding, type: :model do
  describe '#validate' do
    subject { validation_instance.validate(strings) }

    let(:validation_instance) { described_class.new }

    # @note the crazy (+"string") syntax below is required to make
    # frozen_string_literal and rubocop happy. It's just a string.
    let(:string_with_invalid_utf) { (+"\255 is invalid UTF-8").force_encoding('UTF-8') }
    let(:string_disliked_by_postres) { (+"\000 is disliked by postgres").force_encoding('UTF-8') }

    context 'with a single valid string' do
      let(:strings) { 'hello world' }

      it 'is valid' do
        expect(validation_instance.validate(strings)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with multiple valid strings' do
      let(:strings) { ['hello', 'world'] }

      it 'is valid' do
        expect(validation_instance.validate(strings)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with a single invalid string' do
      let(:strings) { string_with_invalid_utf }

      it 'is invalid' do
        expect(validation_instance.validate(strings)).to be_falsey
        expect(validation_instance.errors).to contain_exactly(/contains invalid characters.*is invalid UTF-8/)
      end
    end

    context 'with a multiple invalid strings' do
      let(:strings) { [string_with_invalid_utf, string_disliked_by_postres] }

      it 'is invalid' do
        expect(validation_instance.validate(strings)).to be_falsey
        expect(validation_instance.errors).to contain_exactly(
          /contains invalid characters.*is invalid UTF-8/,
          /contains invalid characters.*is disliked by postgres/
        )
      end
    end

    context 'with both valid and invalid strings' do
      let(:strings) { ['hello world', string_with_invalid_utf] }

      it 'is invalid' do
        expect(validation_instance.validate(strings)).to be_falsey
        expect(validation_instance.errors).to contain_exactly(/contains invalid characters.*is invalid UTF-8/)
      end
    end

    context 'with a nil string' do
      let(:strings) { nil }

      it { is_expected.to be_truthy }
    end

    context 'with an empty set of strings' do
      let(:strings) { [] }

      it { is_expected.to be_truthy }
    end
  end
end
