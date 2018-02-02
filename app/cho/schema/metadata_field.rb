# frozen_string_literal: true

module Schema
  class MetadataField < DataDictionary::Field
    attribute :order_index, Valkyrie::Types::Int
  end
end
