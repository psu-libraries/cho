# frozen_string_literal: true

# Validates a work hash using the Work::Submission::ChangeSet
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
            work_hash['file'] = translate_file_name(work_hash['file_name'])
          end
        end

        def translate_work_type(work_type)
          return nil if work_type.blank?

          work_type_model = Work::Type.find_using(label: work_type).first
          return nil if work_type_model.blank?

          work_type_model.id
        end

        def translate_file_name(file_name)
          return nil if file_name.blank?

          absolute_path = ::File.join(csv_base_path, file_name)
          FileUtils.cp(absolute_path, Rails.root.join('tmp'))
          file = ::File.new(Rails.root.join('tmp', ::File.basename(file_name)))
          ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: ::File.basename(file_name))
        end

        def csv_base_path
          @csv_base_path ||= ::File.absolute_path(ENV['csv_base_path'])
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
