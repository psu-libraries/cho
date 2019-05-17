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

      namespace 'shared' do
        register 'validate' do
          Operations::Shared::Validate.new
        end
        register 'create_change_set' do
          Operations::Shared::CreateChangeSet.new
        end
        register 'save' do
          Operations::Shared::Save.new
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
