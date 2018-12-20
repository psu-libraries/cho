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
          if file_set.text_source.extractable? && file_set.text.nil?
            text_file_result = store_text(text: extract_text(file_set: file_set), file_set: file_set)
            file_set.member_ids += [text_file_result.id]
          end
          Success(file_set)
        rescue StandardError => exception
          Failure(Transaction::Rejection.new("Error extracting text: #{exception.message}"))
        end

        private

          def extract_text(file_set:)
            master_file = file_set.text_source
            output_file_name = temp_file_location(master_file.id)
            Hydra::Derivatives::FullTextExtract.create(master_file.path,
                                                       outputs: [{ file: output_file_name }])
            output_file_name
          end

          def store_text(text:, file_set:)
            file = Work::File.new(original_filename: text_filename(file_set.text_source),
                                  use: [Valkyrie::Vocab::PCDMUse.ExtractedText])
            file_change_set = Work::FileChangeSet.new(file)
            result = Transaction::Operations::File::Create.new.call(file_change_set, temp_file: ::File.new(text))
            return result.success if result.success?

            raise result.failure
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
