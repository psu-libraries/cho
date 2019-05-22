# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Shared::SaveWithChangeSet do
  describe '::steps' do
    let(:steps) { described_class.steps.map(&:name) }

    specify do
      expect(steps).to eq([
                            :validate,
                            :process_file,
                            :import_work,
                            :access_level,
                            :system_creator,
                            :permissions,
                            :save
                          ])
    end
  end

  it { is_expected.to respond_to(:call) }
end
