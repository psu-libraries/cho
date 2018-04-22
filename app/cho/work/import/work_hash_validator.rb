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
        validate_change_set(work_hash)
      end

      private

        def validate_change_set(work_hash)
          @change_set = SubmissionChangeSet.new(Submission.new)
          @change_set.validate(clean_hash(work_hash))
        end

        def clean_hash(work_hash)
          work_hash['member_of_collection_ids'] = translate_collection_ids(work_hash['member_of_collection_ids'])
          work_hash['work_type_id'] = translate_work_type(work_hash['work_type']) if work_hash['work_type_id'].blank?
          work_hash['file'] = translate_file_name(work_hash['file_name'])
          work_hash
        end

        def translate_work_type(work_type)
          return nil if work_type.blank?

          work_type_model = Work::Type.find_using(label: work_type).first
          return nil if work_type_model.blank?

          work_type_model.id
        end

        def translate_collection_ids(member_of_collection_ids)
          if member_of_collection_ids.is_a?(Array)
            member_of_collection_ids
          else
            [member_of_collection_ids]
          end
        end

        def translate_file_name(file_name)
          return nil if file_name.blank?

          FileUtils.cp(file_name, Rails.root.join('tmp'))
          file = ::File.new(Rails.root.join('tmp', ::File.basename(file_name)))
          ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: ::File.basename(file_name))
        end
    end
  end
end
