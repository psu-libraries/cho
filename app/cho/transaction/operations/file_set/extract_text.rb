# frozen_string_literal: true

require 'dry/transaction/operation'

module Transaction
  module Operations
    module FileSet
      class ExtractText
        include Dry::Transaction::Operation

        Hydra::Derivatives.source_file_service = LocalFileService
        Hydra::Derivatives.output_file_service = FileOutputService
        Hydra::Derivatives::FullTextExtract.output_file_service = FileOutputService

        def call(file_set)
          text = extract_text(master_file: master_file(file_set: file_set))
          text_file_result = store_text(file_set: file_set, text: text)
          if text_file_result.success?
            updated_file_set = attach_to_file_set(file: text_file_result.success, file_set: file_set)
            Success(updated_file_set)
          else
            text_file_result
          end
        rescue StandardError => exception
          Failure(Transaction::Rejection.new("Error extracting text: #{exception.message}"))
        end

        private

          def master_file(file_set:)
            Work::File.find(file_set.member_ids.first)
          end

          def extract_text(master_file:)
            output_file_name = temp_file_location(master_file.id)
            Hydra::Derivatives::FullTextExtract.create(master_file.path,
                                                       outputs: [{ file: output_file_name }])
            output_file_name
          end

          def store_text(file_set:, text:)
            file = Work::File.new(original_filename: text_filename(master_file(file_set: file_set)),
                                  use: [Valkyrie::Vocab::PCDMUse.ExtractedText])
            file_change_set = Work::FileChangeSet.new(file)
            Transaction::Operations::File::Create.new.call(file_change_set, temp_file: ::File.new(text))
          end

          def attach_to_file_set(file:, file_set:)
            file_set.member_ids += [file.id]
            file_set
          end

          def text_filename(original_file)
            path = Pathname.new(original_file.original_filename)
            "#{path.basename}_text.txt"
          end

          def temp_file_location(file_id)
            Rails.root.join('tmp', "#{file_id}_extracted_text_#{Time.current.to_i}.txt").to_s
          end
      end
    end
  end
end
