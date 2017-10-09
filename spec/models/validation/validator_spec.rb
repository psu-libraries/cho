# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::Validator, type: :model do
  before (:all) do
    class MyValidator < Validation::Validator
      def validate(_field)
        true
      end
    end
    class OtherValidator < Validation::Validator
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyValidator')
    ActiveSupport::Dependencies.remove_constant('OtherValidator')
  end

  subject { testing_class.new.validate('abc') }

  let(:testing_class) { MyValidator }

  it { within_block_is_expected.not_to raise_exception }

  context 'invalid validator' do
    let(:testing_class) { OtherValidator }

    it { within_block_is_expected.to raise_exception }
  end
end
