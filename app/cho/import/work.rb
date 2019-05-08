# frozen_string_literal: true

class Import::Work
  include ActiveModel::Validations

  validate :must_have_valid_files, :must_have_valid_file_sets

  attr_reader :files, :nested_works, :path

  # @param [Pathname]
  def initialize(path)
    @path = path
    @files = sorted_files
    @nested_works = sorted_works
  end

  def file_sets
    member_ids = files.map(&:file_set_id).uniq
    member_ids.map do |id|
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
        if file_set.representative?
          validate_representative_file_set(file_set)
        else
          validate_file_set(file_set)
        end
      end
    end

    def validate_representative_file_set(file_set)
      return if file_set.access.present?

      errors.add(:file_sets, 'representative does not have an access file')
    end

    def validate_file_set(file_set)
      return if file_set.preservation.present? || file_set.service.present?

      errors.add(:file_sets, "#{file_set} does not have a service or preservation file")
    end

    def sorted_works
      children = path.children.select(&:directory?).map do |directory|
        self.class.new(directory)
      end
      children.sort! { |a, b| a.identifier <=> b.identifier }
    end

    def sorted_files
      children = path.children.select(&:file?).map do |file|
        Import::File.new(file)
      end
      children.sort! { |a, b| a.original_filename <=> b.original_filename }
    end
end
