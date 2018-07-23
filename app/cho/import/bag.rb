# frozen_string_literal: true

class Import::Bag
  include ActiveModel::Validations

  FILENAME_SEPARATOR = '_'

  attr_reader :bag, :date, :batch_id, :work_paths, :works, :path

  validates_presence_of :batch_id
  validate :bag_directory_must_be_dated, :bag_must_be_valid, :works_must_be_valid

  # @param [Pathname] path to the bag
  def initialize(path)
    raise IOError, 'path to bag does not exist or is not readable' unless path.readable?
    @path = path
    @bag = BagIt::Bag.new(path)
    @batch_id, @date = bag.bag_dir.basename.to_s.split(FILENAME_SEPARATOR)
    @work_paths = Pathname.new(@bag.data_dir).children
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
