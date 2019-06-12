# frozen_string_literal: true

# Prepended to JSONValueMapper::DateValue class methods to return only DateTime objects with a timestamp
# and not just an iso8601 date string. This fixes issues where strings that are value EDTF dates such
# as '2001-01-01' are not cast to DateTime objects, but are instead retained as strings for later
# processing as EDTF dates.

require 'date'

module DateTimeJSONValue
  def handles?(value)
    date, time = value.split('T')
    return false unless time

    ::DateTime.iso8601(date)
  rescue StandardError
    false
  end
end
