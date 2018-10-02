# frozen_string_literal: true

module ControlledVocabulary
  class Factory < ItemFactory
    class << self
      alias_method :vocabularies, :items
      alias_method :vocabulary_names, :names
      alias_method :vocabularies=, :items=

      def default_key
        :no_vocabulary
      end

      private

        def default_items
          {
            default_key => ControlledVocabulary::None.new,
            cho_collections: ControlledVocabulary::Collections
          }
        end

        def item_class
          ControlledVocabulary::Base
        end

        def send_error(error_list)
          raise ControlledVocabulary::Error.new("Invalid controlled vocabularies(s) in vocabulary list: #{error_list}")
        end
    end
  end
end
