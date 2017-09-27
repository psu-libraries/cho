# frozen_string_literal: true

module WithFieldType
  extend ActiveSupport::Concern

  included do
    enum field_type: { string: 'string',
                       text: 'text',
                       numeric: 'numeric',
                       date: 'date' }
  end
end
