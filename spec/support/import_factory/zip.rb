# frozen_string_literal: true

# A factory for generating zip files of bags
module ImportFactory
  class Zip
    # @param [ImportFactory::Bag]
    def self.create(bag)
      output_file = Rails.root.join('tmp', 'ingest-test', "#{bag.path.basename}.zip")
      new(bag.path, output_file).write
    end

    attr_reader :input_dir, :output_file

    # @param [Pathname] input_dir
    # @param [Pathname] output_file
    def initialize(input_dir, output_file)
      @input_dir = input_dir
      @output_file = output_file
    end

    def write
      ::Zip::File.open(output_file, ::Zip::File::CREATE) do |zipfile|
        zipfile.mkdir(input_dir.basename)
        write_entries(input_dir.children, zipfile)
      end
    end

    private

      def write_entries(entries, zipfile)
        entries.each do |entry|
          if entry.directory?
            recursively_deflate_directory(entry, zipfile)
          else
            zipfile.add(entry.relative_path_from(input_dir.dirname), entry)
          end
        end
      end

      def recursively_deflate_directory(directory, zipfile)
        zipfile.mkdir(directory.relative_path_from(input_dir.dirname))
        write_entries(directory.children, zipfile)
      end
  end
end
