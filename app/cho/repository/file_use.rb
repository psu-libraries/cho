# frozen_string_literal: true

module Repository
  class FileUse
    attr_reader :uri

    NAME = {
      Vocab::FileUse.RedactedPreservationMasterFile => 'preservation_redacted',
      Vocab::FileUse.PreservationMasterFile => 'preservation',
      Vocab::FileUse.AccessFile => 'access',
      Vocab::FileUse.ExtractedText => 'text',
      Vocab::FileUse.ServiceFile => 'service',
      Vocab::FileUse.ThumbnailImage => 'thumb',
      Vocab::FileUse.FrontImage => 'front',
      Vocab::FileUse.BackImage => 'back'
    }.freeze

    def self.uris
      NAME.keys
    end

    def self.uri_from_suffix(suffix)
      NAME.key(suffix.gsub(/-/, '_'))
    end

    def initialize(fragment)
      fragment ||= 'NoUse'
      @uri = build_uri(fragment)
    end

    def get_method
      return unless uri
      NAME[uri].to_sym
    end

    def set_method
      return unless uri
      "#{NAME[uri]}!".to_sym
    end

    def ask_method
      return unless uri
      "#{NAME[uri]}?".to_sym
    end

    private

      def build_uri(fragment)
        Vocab::FileUse.find_term("#{Vocab::FileUse}#{fragment}")
      rescue KeyError
      end
  end
end
