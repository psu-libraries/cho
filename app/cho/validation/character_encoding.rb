# frozen_string_literal: true

module Validation
  class CharacterEncoding < Base
    # @note you may be wondering why I'm calling `.to_s` a lot here instead of
    # `.blank?`, the reason is because the latter will raise a kind of UTF-8
    # encoding error, but not in a way that is desirable
    def validate(field_value)
      self.errors = []

      Array.wrap(field_value).each do |value|
        unless value.to_s.dup.force_encoding('UTF-8').valid_encoding?
          errors << error_message_for(value)
        end

        if other_bad_characters.any? { |char| value.to_s.include?(char) }
          errors << error_message_for(value)
        end
      end

      errors.empty?
    end

    private

      def other_bad_characters
        [
          0o000.chr(Encoding::UTF_8) # Postgres can't handle this
        ]
      end

      def error_message_for(string_with_encoding_issues)
        invalid_replacement = I18n.t('cho.validation.character_encoding.invalid_character_replacement')

        corrected_string = string_with_encoding_issues
          .encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: invalid_replacement)
          .tr(other_bad_characters.join, invalid_replacement)

        I18n.t(
          'cho.validation.character_encoding.message',
          invalid_character_replacement: invalid_replacement,
          corrected_string: corrected_string
        )
      end
  end
end
