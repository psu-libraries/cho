# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cho::Application do
  describe '#config' do
    subject { described_class.config }

    its(:storage_directory) { is_expected.to eq(Pathname.new(ENV['storage_directory']).expand_path) }
    its(:network_ingest_directory) { is_expected.to eq(Pathname.new(ENV['network_ingest_directory']).expand_path) }
    its(:extraction_directory) { is_expected.to eq(Pathname.new(ENV['extraction_directory']).expand_path) }
  end
end
