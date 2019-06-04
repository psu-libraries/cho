# frozen_string_literal: true

module Repository::AccessControls
  class AccessLevel
    attr_reader :uri

    NAME = {
      Vocab::AccessLevel.Public => 'public',
      Vocab::AccessLevel.PennState => 'registered',
      Vocab::AccessLevel.Restricted => 'private'
    }.freeze

    class << self
      def uris
        NAME.keys
      end

      def names
        NAME.values
      end

      def public
        NAME[Vocab::AccessLevel.Public]
      end

      def penn_state
        NAME[Vocab::AccessLevel.PennState]
      end
      alias psu penn_state

      def restricted
        NAME[Vocab::AccessLevel.Restricted]
      end
    end
  end
end
