# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::ConfigFile do
  let(:config_file) { described_class.new(file: file, requirements: requirements) }

  context 'when the file is missing a required key' do
    let(:file) do
      Tempfile.open do |yaml_file|
        yaml_file.write(Psych.dump('production' => {}))
        Pathname.new(yaml_file.path)
      end
    end

    let(:requirements) { [{ 'required_key' => :required }] }

    specify do
      expect { config_file.validate }
        .to raise_error(Repository::Configuration::Error, "required_key is a required key in #{file.basename}")
    end
  end

  context 'when a directory does not exist' do
    let(:file) do
      Tempfile.open do |yaml_file|
        yaml_file.write(Psych.dump('production' => { 'required_directory' => 'i/do/not/exist' }))
        Pathname.new(yaml_file.path)
      end
    end

    let(:requirements) { [{ 'required_directory' => :required_directory }] }

    specify do
      expect { config_file.validate }
        .to raise_error(Repository::Configuration::Error, "i/do/not/exist is a required directory in #{file.basename}")
    end
  end
end
