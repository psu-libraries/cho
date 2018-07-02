# frozen_string_literal: true

class Import::FileSet
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def representative?
    files.select(&:representative?).count == files.count
  end

  def id
    files.first.file_set_id
  end
  alias_method :to_s, :id
end
