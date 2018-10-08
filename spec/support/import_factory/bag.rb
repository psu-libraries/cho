# frozen_string_literal: true

# Generates bags with different file configurations. All files have valid checksums, but any arbitrary
# filename can be created enabling us to verify directory layout and filenames for conformance.
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
#             |-- someotherid/
#                 |-- file1.tif
#                 |-- file2.txt
#
# The data hash can have any number of entries, each of which would be another directory.

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
        files.each do |file|
          bag.add_file("#{work_id}/#{file}") do |io|
            io.puts file
          end
        end
      end
      bag.manifest!(algo: 'sha256')
      self
    end

    def path
      self.class.root.join(batch_id)
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
