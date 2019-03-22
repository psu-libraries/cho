# frozen_string_literal: true

class Import::File
  include ActiveModel::Validations
  attr_reader :file, :parts

  validate :filename_must_include_work_id, :filename_must_include_type

  class UnknownFileTypeError < StandardError; end

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
    @work_id ||= file.parent.basename.to_s
  end

  def suffix
    @suffix ||= parts.last
  end

  # @return [String] inner most parts of the file
  # @example
  #   Given a filename workID_00002_02_preservation.tif, the returned id would be workID_00002_02
  #   A filename such as workID_preservation.tif has no file set id.
  def file_set_id
    @file_set_id ||= build_file_set_id
  end

  def representative?
    file_set_id.nil?
  end

  def service?
    type == Vocab::FileUse.ServiceFile
  rescue UnknownFileTypeError
    false
  end

  def access?
    type == Vocab::FileUse.AccessFile
  rescue UnknownFileTypeError
    false
  end

  def preservation?
    type == Vocab::FileUse.PreservationMasterFile
  rescue UnknownFileTypeError
    false
  end

  def type
    Repository::FileUse.uri_from_suffix(suffix) ||
      raise(UnknownFileTypeError, "#{self} does not have a valid file type")
  end

  private

    def filename_must_include_work_id
      return if original_filename.starts_with?(work_id)

      errors.add(:file, :filename_must_include_work_id, file: self)
    end

    def filename_must_include_type
      return if type
    rescue UnknownFileTypeError => e
      errors.add(:file, e.message)
    end

    def build_file_set_id
      id = parts.slice(0, (parts.count - 1)).join(Import::Bag::FILENAME_SEPARATOR)
      return if id == work_id

      id
    end
end
