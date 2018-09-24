# frozen_string_literal: true

# Validates a work hash using the Work::SubmissionChangeSet
#
# @example work_hash
#    {'member_of_collection_ids'=>'abc-123', 'work_type_id'=>'def-222', 'title'=>'my awesome work', 'description'=> ''}
module Work
  module Import
    class WorkHashValidator
      attr_reader :change_set, :work_hash

      def initialize(work_hash)
        @work_hash = work_hash
        @change_set = build_change_set
        clean_hash
        @change_set.validate(work_hash)
      end

      private

        def updating?
          work_hash.key?('id')
        end

        def build_change_set
          if submission.nil?
            MissingChangeSet.new(MissingResource.new)
          else
            SubmissionChangeSet.new(submission)
          end
        end

        def submission
          @submission ||= if updating?
                            Submission.find(Valkyrie::ID.new(work_hash['id']))
                          else
                            Submission.new
                          end
        end

        def clean_hash
          work_hash['member_of_collection_ids'] = Array.wrap(work_hash['member_of_collection_ids'])
          unless updating?
            work_hash['work_type_id'] = translate_work_type(work_hash['work_type']) if work_hash['work_type_id'].blank?
          end
        end

        def translate_work_type(work_type)
          return nil if work_type.blank?

          work_type_model = Work::Type.find_using(label: work_type).first
          return nil if work_type_model.blank?

          work_type_model.id
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
