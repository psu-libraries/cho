# frozen_string_literal: true

# Validates a work hash using the Work::SubmissionChangeSet
#
# @example resource_hash
#    {'member_of_collection_ids'=>'abc-123', 'work_type_id'=>'def-222', 'title'=>'my awesome work', 'description'=> ''}
module Work
  module Import
    class WorkHashValidator < Csv::HashValidator
      private

        def validate
          clean_hash
          super
        end

        def clean_hash
          resource_hash['member_of_collection_ids'] = Array.wrap(resource_hash['member_of_collection_ids'])
          unless updating? || work_type.blank?
            resource_hash['work_type_id'] = work_type.id
          end
        end

        def work_type
          @work_type ||= begin
                           label = resource_hash.fetch('work_type', nil)
                           Work::Type.find_using(label: label).first
                         end
        end
    end
  end
end
