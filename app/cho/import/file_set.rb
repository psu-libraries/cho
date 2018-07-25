# frozen_string_literal: true

class Import::FileSet
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def representative?
    files.select(&:representative?).count == files.count
  end

  def title
    if preservation
      preservation.original_filename
    elsif service
      service.original_filename
    end
  end

  def id
    files.first.file_set_id
  end
  alias_method :to_s, :id

  private

    def preservation
      @preservation ||= files.select(&:preservation?).first
    end

    def service
      @service ||= files.select(&:service?).first
    end
end
