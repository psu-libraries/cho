# frozen_string_literal: true

module ControlledVocabulary
  class Factory
    class << self
      def vocabularies=(new_vocabularies)
        non_vocabularies = new_vocabularies.reject { |_label, vocabulary| vocabulary.is_a? ControlledVocabulary::Base }
        if non_vocabularies.present?
          error_list = non_vocabularies.keys.join(', ')
          raise Error.new("Invalid controlled vocabularies(s) in vocabulary list: #{error_list}")
        end

        @vocabularies = new_vocabularies.merge(default_vocabulary)
      end

      def vocabularies
        @vocabularies ||= default_vocabulary
      end

      def lookup(vocabulary_name)
        vocabularies[vocabulary_name]
      end

      def vocabulary_names
        vocabularies.keys.map(&:to_s)
      end

      private

        def default_vocabulary
          { no_vocabulary: ControlledVocabulary::None.new }
        end
    end
  end
end
