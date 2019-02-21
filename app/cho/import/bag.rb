# frozen_string_literal: true

class Import::Bag
  include ActiveModel::Validations

  FILENAME_SEPARATOR = '_'

  attr_reader :bag, :batch_id, :work_paths, :works, :path

  validates_presence_of :batch_id
  validate :bag_must_be_valid, :works_must_be_valid

  # @param [Pathname] path to the bag
  def initialize(path)
    raise IOError, 'path to bag does not exist or is not readable' unless path.readable?

    @path = path
    @bag = BagIt::Bag.new(path)
    @batch_id = bag.bag_dir.basename.to_s
    @work_paths = Pathname.new(@bag.data_dir).children
  end

  # @return [String]
  # If the last segment of the batch id is a date in the appropriate format, return the date.
  # Otherwise, we'll assume anything else is not a date and return nil.
  def date
    date_segment = batch_id.split(FILENAME_SEPARATOR).last
    Date.strptime(date_segment, '%Y-%m-%d')
    date_segment
  rescue ArgumentError
  end

  private

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

    def works_must_be_valid
      @works = work_paths.map { |work_path| build_work(work_path) }
      @works.compact.reject(&:valid?).map do |bad_work|
        bad_work.errors.messages.each_value do |work_errors|
          work_errors.map { |work_error| errors.add(:works, work_error) }
        end
      end
    end

    def build_work(work_path)
      Import::Work.new(work_path)
    rescue Errno::ENOTDIR
      errors.add(:bag, "#{work_path.basename} cannot be under data")
      nil
    end
end
