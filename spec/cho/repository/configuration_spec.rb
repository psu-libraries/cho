# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Configuration do
  describe '::check' do
    context 'with the current configuration files' do
      specify do
        expect { described_class.check }.not_to raise_error(Repository::Configuration::Error)
      end
    end
  end
end
