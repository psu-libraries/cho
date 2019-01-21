# frozen_string_literal: true

module Csv
  class HashValidator
    attr_reader :resource_hash, :resource_class, :change_set_class

    def initialize(resource_hash, change_set_class:, resource_class:)
      @resource_class = resource_class
      @change_set_class = change_set_class
      @resource_hash = resource_hash
      validate
    end

    def change_set
      @change_set ||= if resource.nil?
                        MissingChangeSet.new(MissingResource.new)
                      else
                        change_set_class.new(resource)
                      end
    end

    private

      def updating?
        resource_hash.key?('id')
      end

      def validate
        change_set.validate(resource_hash)
      end

      def resource
        @resource ||= if updating?
                        resource_class.find(Valkyrie::ID.new(resource_hash['id']))
                      else
                        resource_class.new
                      end
      end

      class MissingResource < Valkyrie::Resource
      end

      class MissingChangeSet < Valkyrie::ChangeSet
        def errors
          current_errors = super
          current_errors.add(:id, 'does not exist') unless current_errors.key?(:id)
          current_errors
        end

        def valid?
          false
        end
      end
  end
end
