# frozen_string_literal: true

module Collection
  class RepresentativeImagePresenter
    attr_reader :document

    def initialize(document, *_rest)
      @document = document
    end

    def basename
      @basename ||= begin
                      Array.wrap(document.alternate_ids_data_dictionary_field)
                        .first
                        .to_s
                        .downcase
                        .sub(/^id-/, '')
                        .presence
                    end
    end

    def identifier
      @identifier ||= begin
                        supported_formats
                          .map { |format| "#{basename}.#{format}" }
                          .find { |filename| File.exist? filesystem_path.join(filename) }
                      end
    end

    def exists?
      identifier.present?
    end

    def path
      exists? ? url_path_for(identifier) : '/default-collection-image.png'
    end

    private

      def url_path_for(filename)
        "/#{base_url_path}/#{filename}"
      end

      # Turns "public/collection_images" into "collection_images"
      def base_url_path
        @base_url_path = begin
                           filesystem_path
                             .to_s
                             .split('public/')
                             .last
                             .gsub(/^\/|\/$/, '') # strip any leading/trailing slashes
                         end
      end

      def filesystem_path
        Cho::Application.config.collection_image_directory
      end

      def supported_formats
        %w[jpg jpeg png gif]
      end
  end
end
