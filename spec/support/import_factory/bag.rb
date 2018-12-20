# frozen_string_literal: true

# Generates bags with different file configurations. All files have valid checksums, but any arbitrary
# filename can be created enabling us to verify directory layout and filenames for conformance.
# Unless a hash is used to point to a specific fixture (see second example below), all files have text
# content, regardless of the actual mime type. By default, the content of each file is just its name; however,
# extracted text files that are denoted by the _text.txt ending, have some ipsum text for testing.
#
# @example
#
# > ImportFactory::Bag.create(batch_id: "someid", data: { someotherid: [ "file1.tif", "file2.txt"] })
#
# Will produce a bag like:
# |-- someid_YYYY-MM-DD/
#     |-- bag-info.txt
#     |-- bagit.txt
#     |-- manifest-md5.txt
#     |-- tagmanifest-md5.txt
#     |-- data/
#         |-- someotherid/
#             |-- file1.tif
#             |-- file2.txt
#
# The data hash can have any number of entries, each of which would be another directory.
#
# File entries can be either strings or hashes. Providing a hash allows you to specify a specific
# file from the spec/fixtures directory to use for the content of the file.
#
# @example
#
# > ImportFactory::Bag.create(batch_id: "someid", data: { someotherid: [ { name: "file1.pdf", file: "test.pdf" } ] })
#
# Will produce a bag like:
# |-- someid_YYYY-MM-DD/
#     |-- bag-info.txt
#     |-- bagit.txt
#     |-- manifest-md5.txt
#     |-- tagmanifest-md5.txt
#     |-- data/
#         |-- someotherid/
#             |-- file1.pdf
#
# Where file1.pdf has the content of spec/fixtures/test.pdf

module ImportFactory
  class Bag
    attr_reader :batch_id, :data

    def self.create(**args)
      bag = new(args).build
      Import::Bag.new(bag.path)
    end

    def self.root
      Rails.root.join('tmp', 'import-factory')
    end

    def initialize(batch_id:, data:)
      @batch_id = batch_id
      @data = data
    end

    def build
      data.each do |work_id, files|
        files.each do |entry|
          file = FileEntry.new(entry)
          bag.add_file("#{work_id}/#{file}") do |io|
            io.puts file.content
          end
        end
      end
      bag.manifest!(algo: 'sha256')
      self
    end

    def path
      self.class.root.join(batch_id)
    end

    class FileEntry
      attr_reader :entry

      def initialize(entry)
        @entry = entry
      end

      def to_s
        return entry if entry.is_a?(String)

        entry.fetch(:name)
      end

      # @note Returns content from the file, if it is specified, or generates some.
      def content
        return generated_content if entry.is_a?(String)

        ::File.read(Rails.root.join('spec', 'fixtures', entry.fetch(:file)))
      end

      # @note By default, the file's content is just its name unless its a file used for extracted text
      #   and then we generate some ipsum for it.
      def generated_content
        return entry unless entry.ends_with?('_text.txt')

        Faker::Lorem.paragraphs.join(' ')
      end
    end

    private

      def bag
        @bag ||= begin
                   FileUtils.rm_rf(path)
                   FileUtils.mkdir_p(path)
                   BagIt::Bag.new(path)
                 end
      end
  end
end
