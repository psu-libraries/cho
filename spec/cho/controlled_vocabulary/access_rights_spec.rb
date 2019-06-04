# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::AccessRights, type: :model do
  describe '::list' do
    subject { described_class.list }

    it { is_expected.to contain_exactly('public', 'registered', 'private') }
  end
end
