# frozen_string_literal: true

module Transaction
  module Operations
    module FileSet
      class FileOutputService < Hydra::Derivatives::PersistOutputFileService
        def self.call(string_or_stream, directives)
          output_file(directives) do |output|
            if string_or_stream.is_a?(String)
              output.write(string_or_stream)
            else
              IO.copy_stream(string_or_stream, output)
            end
            output.close
          end
        end

        # Open the output file to write and yield the block to the
        # file. It makes the directories in the path if necessary.
        def self.output_file(directives)
          raise ArgumentError, 'No :temp_file was provided in the transcoding directives' unless directives.key?(:file)

          temp_file = ::File.open(directives[:file], 'wb')
          yield(temp_file)
          temp_file
        end
      end
    end
  end
end
