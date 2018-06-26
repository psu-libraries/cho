# frozen_string_literal: true

module Schema
  class UniqueValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, _value)
      result = Valkyrie.config.metadata_adapter.query_service.custom_queries
        .find_using(label: record.label, work_type: record.work_type)
      if result.count.positive? && (result.first.id != record.id)
        record.errors.add attribute, 'work_type and label must be unique'
      end
    end
  end
end
