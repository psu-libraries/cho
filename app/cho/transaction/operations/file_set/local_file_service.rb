# frozen_string_literal: true

module Transaction
  module Operations
    module FileSet
      class LocalFileService
        def self.call(file_name, _options)
          yield ::File.open(file_name)
        end
      end
    end
  end
end
