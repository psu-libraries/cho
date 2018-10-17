# frozen_string_literal: true

module Work
  class FileSetIndexer
    attr_reader :resource
    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      return {} unless resource.is_a?(Work::FileSet)
      { all_text_timv: extracted_text_content }
    end

    private

      def extracted_text_content
        return unless extracted_text?
        ::File.read(Work::File.find(files.select(&:text?).first.id).path)
      end

      def extracted_text?
        extracted_text.present?
      end

      def extracted_text
        files.select(&:text?)
      end

      def files
        @files ||= resource.member_ids.map { |id| Work::File.find(id) }
      end
  end
end
