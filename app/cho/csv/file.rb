# frozen_string_literal: true

module Csv
  class File
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    def persisted?
      false
    end
    # Accessors needed for shrine to send the temporary uploaded file
    #  to the controller
    # For the moment we are uploading a single file.
    attr_accessor :id, :file_data, :cached_file_data, :file
  end
end
