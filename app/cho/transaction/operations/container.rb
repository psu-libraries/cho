# frozen_string_literal: true

require 'dry/container'
require 'dry/transaction'
require 'dry/transaction/operation'

module Transaction
  module Operations
    class Container
      extend Dry::Container::Mixin

      namespace 'file' do
        register 'save' do
          Operations::File::Save.new
        end
        register 'validate' do
          Operations::File::Validate.new
        end
        register 'delete' do
          Operations::File::Delete.new
        end
      end
    end
  end
end
