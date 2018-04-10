# frozen_string_literal: true

# Validates a work hash using the Work::Submission::ChangeSet
#
# @example work_hash
#    {'member_of_collection_ids'=>'abc-123', 'work_type_id'=>'def-222', 'title'=>'my awesome work', 'description'=> ''}
module Work
  module Import
    class WorkHashValidator
      attr_reader :change_set

      def initialize(work_hash)
        @change_set = SubmissionChangeSet.new(Submission.new)
        collection_id = work_hash['member_of_collection_ids']
        work_hash['member_of_collection_ids'] = [collection_id] unless collection_id.is_a?(Array)
        @change_set.validate(work_hash)
      end
    end
  end
end
