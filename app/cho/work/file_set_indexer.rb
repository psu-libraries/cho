# frozen_string_literal: true

module Work
  class FileSetIndexer
    attr_reader :resource
    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      return {} unless resource.is_a?(Work::FileSet)
      {
        all_text_timv: extracted_text_content,
        thumbnail_path_ss: thumbnail_path
      }
    end

    private

      def extracted_text_content
        return if resource.text.nil?
        ::File.read(resource.text.path)
      end

      def thumbnail_path
        return if resource.thumbnail.nil?
        resource.thumbnail.path.to_s
      end
  end
end
