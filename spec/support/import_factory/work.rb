# frozen_string_literal: true

# A factory for generating works that are found in bags.
module ImportFactory
  class Work
    # @param [Hash] data
    # @return [Import::Work]
    def self.new_create(data)
      service = new(data)
      Import::Work.new(service.base_dir)
    end

    attr_reader :base_dir

    def initialize(data)
      directory = data.keys.first
      entries = data[directory]
      @base_dir = Rails.root.join('tmp', directory.to_s)
      call(entries)
    end

    def call(entries)
      FileUtils.rm_rf(base_dir)
      build(entries, base_dir)
    end

    private

      def build(entries, root)
        FileUtils.mkdir_p(root)
        entries.each do |entry|
          if entry.is_a?(Hash)
            directory = entry.keys.first
            entries = entry[directory]
            path = Rails.root.join(root, directory.to_s)
            build(entries, path)
          else
            path = Rails.root.join(root, entry)
            FileUtils.touch(path)
          end
        end
      end
  end
end
