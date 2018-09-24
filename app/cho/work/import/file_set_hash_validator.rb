# frozen_string_literal: true

# Validates a file set hash using the Work::FileSetChangeSet
#
# @example file_set_hash
#    {'title'=>'my awesome work', 'description'=> 'some description'}
module Work
  module Import
    class FileSetHashValidator
      attr_reader :change_set, :file_set_hash

      def initialize(file_set_hash)
        @file_set_hash = file_set_hash
        @change_set = build_change_set
        @change_set.validate(file_set_hash)
      end

      private

        def updating?
          file_set_hash.key?('id')
        end

        def build_change_set
          if file_set.nil?
            MissingChangeSet.new(MissingResource.new)
          else
            FileSetChangeSet.new(file_set)
          end
        end

        def file_set
          @file_set ||= if updating?
                          FileSet.find(Valkyrie::ID.new(file_set_hash['id']))
                        else
                          FileSet.new
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
end
