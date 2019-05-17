# frozen_string_literal: true

require 'dry/transaction/operation'
require 'zip'

module Transaction
  module Operations
    module Import
      class Extract
        include Dry::Transaction::Operation

        # @param [String] zip_name name of the zip file or batch id containing the bag
        # @param [Pathname] zip_path full path to the zip file containing the bag
        def call(zip_name: nil, zip_path: nil)
          zip_name ||= zip_path.basename('.zip')
          zip_path ||= Cho::Application.config.network_ingest_directory.join("#{zip_name}.zip")
          destination = Cho::Application.config.extraction_directory.join(zip_name)
          FileUtils.rm_rf(destination)

          unzip_bag(zip_path)
          Success(destination)
        rescue StandardError => e
          Failure(Transaction::Rejection.new('Error extracting the bag', e))
        end

        private

          # @param [String] path to zip file
          def unzip_bag(path)
            ::Zip::File.open_buffer(::File.open(path)) do |zip_file|
              zip_file.each do |entry|
                path = Cho::Application.config.extraction_directory.join(entry.name)
                FileUtils.mkdir_p(path.dirname)
                zip_file.extract(entry, path) unless path.exist?
              end
            end
          end
      end
    end
  end
end
