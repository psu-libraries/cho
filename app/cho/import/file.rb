# frozen_string_literal: true

class Import::File
  include ActiveModel::Validations
  attr_reader :file, :parts

  validate :filename_must_include_work_id, :filename_must_include_type

  class UnknownFileTypeError < StandardError; end

  TYPES = {
    'preservation' => Valkyrie::Vocab::PCDMUse.PreservationMasterFile,
    'preservation-redacted' => Vocab::FileUse.RedactedPreservationMasterFile,
    'service' => Valkyrie::Vocab::PCDMUse.ServiceFile,
    'text' => Valkyrie::Vocab::PCDMUse.ExtractedText,
    'access' => Vocab::FileUse.AccessFile,
    'thumb' => Valkyrie::Vocab::PCDMUse.ThumbnailImage,
    'front' => Vocab::FileUse.FrontImage,
    'back' => Vocab::FileUse.BackImage
  }.freeze

  # @param [Pathname] file
  def initialize(file)
    @file = file
    @parts = file.basename(File.extname(file)).to_s.split(Import::Bag::FILENAME_SEPARATOR)
  end

  def to_s
    file.basename.to_s
  end
  alias_method :original_filename, :to_s

  def path
    file.to_s
  end

  def work_id
    @work_id ||= parts.first
  end

  def suffix
    @suffix ||= parts.last
  end

  # @return [String] inner most parts of the file
  # @example
  #   Given a filename workID_00002_02_preservation.tif, the returned id would be workID_00002_02
  #   A filename such as workID_preservation.tif has no file set id.
  def file_set_id
    @file_set_id ||= begin
                       return if parts.count == 2
                       parts.pop
                       parts.join(Import::Bag::FILENAME_SEPARATOR)
                     end
  end

  def representative?
    file_set_id.nil?
  end

  def service?
    type == Valkyrie::Vocab::PCDMUse.ServiceFile
  rescue UnknownFileTypeError
    false
  end

  def preservation?
    type == Valkyrie::Vocab::PCDMUse.PreservationMasterFile
  rescue UnknownFileTypeError
    false
  end

  def type
    TYPES.fetch(suffix) do
      raise(UnknownFileTypeError, "#{self} does not have a valid file type")
    end
  end

  private

    def filename_must_include_work_id
      return if work_id == file.parent.basename.to_s
      errors.add(:file, :filename_must_include_work_id, file: self)
    end

    def filename_must_include_type
      return if type
    rescue UnknownFileTypeError => e
      errors.add(:file, e.message)
    end
end
