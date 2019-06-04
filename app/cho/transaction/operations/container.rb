# frozen_string_literal: true

require 'dry/container'
require 'dry/transaction'
require 'dry/transaction/operation'

module Transaction
  module Operations
    class Container
      extend Dry::Container::Mixin

      namespace 'file' do
        register 'characterize' do
          Operations::File::Characterize.new
        end
        register 'process' do
          Operations::File::Process.new
        end
        register 'save' do
          Operations::File::Save.new
        end
      end

      namespace 'change_set' do
        register 'validate' do
          Operations::ChangeSet::Validate.new
        end
        register 'create' do
          Operations::ChangeSet::Create.new
        end
        register 'save' do
          Operations::ChangeSet::Save.new
        end
      end

      namespace 'access_controls' do
        register 'access_level' do
          Operations::AccessControls::AccessLevel.new
        end
        register 'system_creator' do
          Operations::AccessControls::SystemCreator.new
        end
        register 'permissions' do
          Operations::AccessControls::Permissions.new
        end
      end

      namespace 'import' do
        register 'extract' do
          Operations::Import::Extract.new
        end
        register 'validate' do
          Operations::Import::Validate.new
        end
        register 'work' do
          Operations::Import::Work.new
        end
      end
    end
  end
end
