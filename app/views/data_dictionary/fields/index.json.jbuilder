# frozen_string_literal: true

json.array! @data_dictionary_fields.to_a, partial: 'dictionary_field', as: :data_dictionary_field
