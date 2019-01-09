# frozen_string_literal: true

module Work::WithUseType
  extend ActiveSupport::Concern

  USE_TYPE_URIS = [
    Valkyrie::Vocab::PCDMUse.ExtractedText,
    Valkyrie::Vocab::PCDMUse.PreservationMasterFile,
    Vocab::FileUse.RedactedPreservationMasterFile,
    Vocab::FileUse.AccessFile,
    Valkyrie::Vocab::PCDMUse.ServiceFile,
    Valkyrie::Vocab::PCDMUse.ThumbnailImage
  ].freeze

  class UseTypes
    def self.call(value)
      raise Dry::Struct::Error, "#{value} is not a valid use type" unless valid?(value)

      value
    end

    def self.valid?(value)
      USE_TYPE_URIS.include?(value)
    end
  end

  included do
    attribute :use, Valkyrie::Types::Set.member(UseTypes).default([Valkyrie::Vocab::PCDMUse.PreservationMasterFile])
  end

  def preservation!
    self.use = [Valkyrie::Vocab::PCDMUse.PreservationMasterFile]
  end

  def preservation?
    use.include?(Valkyrie::Vocab::PCDMUse.PreservationMasterFile)
  end

  def preservation_redacted!
    self.use = [Vocab::FileUse.RedactedPreservationMasterFile]
  end

  def preservation_redacted?
    use.include?(Vocab::FileUse.RedactedPreservationMasterFile)
  end

  def text!
    self.use = [Valkyrie::Vocab::PCDMUse.ExtractedText]
  end

  def text?
    use.include?(Valkyrie::Vocab::PCDMUse.ExtractedText)
  end

  def access!
    self.use = [Vocab::FileUse.AccessFile]
  end

  def access?
    use.include?(Vocab::FileUse.AccessFile)
  end

  def service!
    self.use = [Valkyrie::Vocab::PCDMUse.ServiceFile]
  end

  def service?
    use.include?(Valkyrie::Vocab::PCDMUse.ServiceFile)
  end

  def thumbnail!
    self.use = [Valkyrie::Vocab::PCDMUse.ThumbnailImage]
  end

  def thumbnail?
    use.include?(Valkyrie::Vocab::PCDMUse.ThumbnailImage)
  end
end
