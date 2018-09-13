# frozen_string_literal: true

class Import::Work
  include ActiveModel::Validations

  validate :must_have_valid_files, :must_have_valid_file_sets

  attr_reader :files, :nested_works, :path

  # @param [Pathname]
  def initialize(path)
    @path = path
    @files = path.children.select(&:file?).map { |file| Import::File.new(file) }
    @nested_works = path.children.select(&:directory?).map { |directory| self.class.new(directory) }
  end

  def file_sets
    file_set_ids = files.map(&:file_set_id).uniq
    file_set_ids.map do |id|
      Import::FileSet.new(files.select { |file| file.file_set_id == id })
    end
  end

  def representative
    file_sets.select(&:representative?).first
  end

  def identifier
    path.basename.to_s
  end

  private

    def must_have_valid_files
      files.reject(&:valid?).each do |file|
        file.errors.full_messages.each do |error|
          errors.add(:files, error)
        end
      end
    end

    def must_have_valid_file_sets
      file_sets.each do |file_set|
        if file_set.files.select(&:service?).empty? && file_set.files.select(&:preservation?).empty?
          errors.add(:file_sets, file_set_error(file_set))
        end
      end
    end

    def file_set_error(file_set)
      if file_set.representative?
        'representative does not have a service file'
      else
        "#{file_set} does not have a service or preservation file"
      end
    end
end
