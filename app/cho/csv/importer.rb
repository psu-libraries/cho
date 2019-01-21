# frozen_string_literal: true

module Csv
  # Runs the import process assuming each item in the list is valid
  #  Each item in the list is a change set that can be persisted
  #
  # importer = Csv::Importer.new(change_set_list)
  # if importer.run
  #   puts "The import was successful"
  # else
  #   puts there import failed
  #   importer.errors.each {|error| puts error }
  # end
  #
  class Importer
    attr_reader :change_set_list, :errors, :created

    def initialize(change_set_list, change_set_persister = nil)
      @change_set_list = change_set_list
      @change_set_persister = change_set_persister
      @errors = []
      @created = []
    end

    def run
      return false unless valid_list?

      change_set_list.each do |change_set|
        result = change_set_persister.validate_and_save(change_set: change_set, resource_params: {})
        if result.errors.blank?
          created << result
        else
          errors << result
        end
      end
      errors.empty?
    end

    private

      def valid_list?
        state = change_set_list.map(&:valid?).reduce(:'&')
        errors << 'Invalid items in list' unless state
        state
      end

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(
          metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
          storage_adapter: Valkyrie.config.storage_adapter
        )
      end
  end
end
