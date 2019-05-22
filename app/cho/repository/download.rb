# frozen_string_literal: true

module Repository
  class Download
    attr_reader :id, :use, :current_ability

    def initialize(id:, use: nil, current_ability: Ability.new(nil))
      @id = id
      @use = FileUse.new(use)
      @current_ability = current_ability
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
    delegate :get_method, to: :use

    private

      def select_file
        return default_file unless get_method

        if use.uri == Vocab::FileUse.PreservationMasterFile && current_ability.admin?
          file_set.files.select(&:preservation?).first
        else
          file_set.send(get_method)
        end
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
