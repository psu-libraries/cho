# frozen_string_literal: true

require 'edtf'

module Indexing
  class EdtfDateRangeFormatter
    class << self
      def format(date)
        edtf_date = parse_date_into_edtf(date)

        if edtf_date.nil?
          return
        elsif edtf_date.is_a? EDTF::Interval
          format_interval(edtf_date)
        elsif edtf_date.certain?
          format_date(edtf_date)
        else
          format_uncertain_date(edtf_date)
        end
      end

      private

        def format_date(date)
          case specified_precision(date)
          when :day then
            date.strftime('%Y-%m-%d')
          when :month
            date.strftime('%Y-%m')
          when :year
            date.strftime('%Y')
          end
        end

        def format_uncertain_date(uncertain_date)
          potential_date_range = build_uncertainty_range(uncertain_date)

          format_range(potential_date_range)
        end

        def format_range(date_range)
          min = date_range.min
          max = date_range.max
          "[#{format_date min} TO #{format_date max}]"
        end

        # @note an Interval can contain uncertain dates on either side. Any
        # uncertain date will first be "exploded" out into a potential range,
        # then the largest span possible is taken.
        def format_interval(interval)
          min = interval.min
          max = interval.max

          if min.uncertain?
            min = build_uncertainty_range(min).min
          end

          if max.uncertain?
            max = build_uncertainty_range(max).max
          end

          interval_range = (min..max)

          format_range(interval_range)
        end

        def build_uncertainty_range(uncertain_date)
          precision, delta = case uncertain_date.precision
                             when :day
                               [:days, 1]
                             when :month
                               [:months, 1]
                             when :year
                               [:years, 1]
                             end

          min = uncertain_date.advance(precision => -delta)
          max = uncertain_date.advance(precision => delta)

          (min..max)
        end

        # @note you can provide a date like '2019-uu-uu'... the edtf gem would tell
        # you that this date has a precision of :day, which is not useful for our
        # purposes because only the year is specified. In this example, this
        # function would return :year
        def specified_precision(date)
          potential_precision_levels = case date.precision
                                       when :day
                                         [:day, :month, :year]
                                       when :month
                                         [:month, :year]
                                       when :year
                                         [:year]
                                       end

          potential_precision_levels.find { |level| date.specific?(level) }
        end

        # Idempotently parse strings into edtf dates
        def parse_date_into_edtf(date)
          if date.respond_to?(:edtf)
            date
          else
            Date.edtf(date)
          end
        end
    end
  end
end
