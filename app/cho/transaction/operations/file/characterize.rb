# frozen_string_literal: true

module Transaction
  module Operations
    module File
      class Characterize
        include Dry::Transaction::Operation

        def call(change_set)
          # get the original file
          # run the file through fits
          xml_string = characterize(change_set)

          # store the output to a file property
          change_set.validate(fits_output: xml_string)

          Success(change_set)
        rescue StandardError => e
          Failure("Error characterizing file: #{e.message}")
        end

        private

          def characterize(change_set)
            file = Valkyrie.config.storage_adapter.find_by(id: change_set.resource.file_identifier)
            Hydra::FileCharacterization.characterize(file.io, change_set.original_filename, :fits)
          end
      end
    end
  end
end
