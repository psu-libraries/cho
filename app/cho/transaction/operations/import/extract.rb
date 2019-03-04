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
          zip_path ||= network_ingest_directory.join("#{zip_name}.zip")
          destination = extraction_directory.join(zip_name)
          FileUtils.rm_rf(destination)

          unzip_bag(zip_path)
          Success(destination)
        rescue StandardError => exception
          Failure(Transaction::Rejection.new("Error extracting the bag: #{exception.message}"))
        end

        private

          # @param [String] path to zip file
          def unzip_bag(path)
            ::Zip::File.open_buffer(::File.open(path)) do |zip_file|
              zip_file.each do |entry|
                path = extraction_directory.join(entry.name)
                FileUtils.mkdir_p(path.dirname)
                zip_file.extract(entry, path) unless path.exist?
              end
            end
          end

          def network_ingest_directory
            @network_ingest_directory ||= Pathname.new(ENV['network_ingest_directory']).expand_path
          end

          def extraction_directory
            @extraction_directory ||= Pathname.new(ENV['extraction_directory']).expand_path
          end
      end
    end
  end
end
