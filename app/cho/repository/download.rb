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
        get_method = FileUse.new(use).get_method
        return default_file unless get_method

        file_set.send(get_method)
      end

      def default_file
        file_set.service || file_set.access || file_set.preservation
      end

      def file_set
        @file_set ||= Valkyrie.config.metadata_adapter.query_service.find_by(id: Valkyrie::ID.new(id))
      rescue Valkyrie::Persistence::ObjectNotFoundError
      end
  end
end
