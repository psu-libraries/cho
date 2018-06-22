# frozen_string_literal: true

# A factory for generating files that are found in bags
module ImportFactory
  class File
    # @param [String] file
    # @param [String] parent
    # @return [Import::File]
    def self.create(file, parent: nil)
      parent ||= file.split(/_/).first
      base_dir = Rails.root.join('tmp', parent)
      FileUtils.rm_rf(base_dir)
      FileUtils.mkdir_p(base_dir)
      path = Rails.root.join(base_dir, file)
      FileUtils.touch(path)
      Import::File.new(path)
    end
  end
end
