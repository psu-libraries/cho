# frozen_string_literal: true

module MetadataApplicationProfile::WithVocabularies
  extend ActiveSupport::Concern

  FieldVocablaries = Valkyrie::Types::String.enum(*ControlledVocabulary::Factory.vocabulary_names)

  included do
    attribute :controlled_vocabulary, FieldVocablaries
  end
end
