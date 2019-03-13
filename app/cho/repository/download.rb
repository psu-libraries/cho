# frozen_string_literal: true

module Repository
  class Download
    attr_reader :id, :use

    def initialize(id:, use: nil)
      @id = id
      @use = use
    end

    def available?
      file.present? && Pathname.new(file.path).exist?
    end

    def file
      @file ||= begin
                  return if file_set.nil?
                  select_file
                end
    end

    delegate :path, to: :file

    private

      def select_file
        case use
        when 'PreservationMasterFile'
          preservation_file
        when 'ServiceFile'
          file_set.service
        when 'AccessFile'
          file_set.access
        else
          default_file
        end
      end

      def preservation_file
        file_set.preservation_redacted || file_set.preservation
      end

      def default_file
        file_set.service || preservation_file
      end

      def file_set
        @file_set ||= Valkyrie.config.metadata_adapter.query_service.find_by(id: Valkyrie::ID.new(id))
      rescue Valkyrie::Persistence::ObjectNotFoundError
      end
  end
end
