# frozen_string_literal: true

module DataDictionary
  class UniqueValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      result = Valkyrie.config.metadata_adapter.query_service.custom_queries.find_using(attribute => value)
      if result.count.positive? && (result.first.id != record.id)
        record.errors.add attribute, 'must be unique'
      end
    end
  end
end
