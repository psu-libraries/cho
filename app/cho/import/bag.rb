# frozen_string_literal: true

class Import::Bag
  include ActiveModel::Validations

  FILENAME_SEPARATOR = '_'

  attr_reader :bag, :date, :batch_id, :work_paths

  validates_presence_of :batch_id
  validate :bag_directory_must_be_dated, :bag_must_be_valid, :files_cannot_be_in_data

  # @param [Pathname] path to the bag
  def initialize(path)
    @bag = BagIt::Bag.new(path)
    @batch_id, @date = bag.bag_dir.basename.to_s.split(FILENAME_SEPARATOR)
    @work_paths = Pathname.new(@bag.data_dir).children
  end

  def works
    work_paths.map do |work_path|
      Import::Work.new(work_path)
    end
  end

  private

    def bag_directory_must_be_dated
      if date.nil?
        errors.add(:date, 'cannot be blank')
      else
        Date.strptime(date, '%Y-%m-%d')
      end
    rescue ArgumentError
      errors.add(:date, "#{date} is not in YYYY-MM-DD format")
    end

    def files_cannot_be_in_data
      files = work_paths.select(&:file?)
      return if files.empty?
      files.each do |file|
        errors.add(:bag, "#{file.basename} cannot be under data")
      end
    end

    def bag_must_be_valid
      return if bag.valid?
      bag_errors(bag).each do |message|
        errors.add(:bag, message)
      end
    end

    # @param [BagIt::Bag] bag
    # @return [Array]
    # @note list of individual error messages in the bag as reported by BagIt
    def bag_errors(bag)
      bag.errors.map { |error| error[1] }.flatten
    end
end
