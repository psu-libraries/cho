# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'default email from' do
    subject { described_class.default[:from] }

    it { is_expected.to eq('from@example.com') }
  end
end
