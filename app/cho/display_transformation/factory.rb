# frozen_string_literal: true

# The keys to the default_items should point at valid display transformation helpers
#   The helpers need to handle both a single item transformation for the facets
# and a list of items for the show and index views
#
# @example of a valid helper
#  def transformation_helper(options_hash_or_value)
#     if options_hash_or_value.is_a? Hash
#        # deal with the list
#        options_hash_or_value[:document].field.map(&:titleize)
#     else
#        # deal with one value
#        options_hash_or_value.titleize
#     end
#   end
#
#
# Right now the only thing being utilized from this class is the transformation_names.
# I am leaving this class inplace to see if it makes sense in the future when we have another transformations
#
module DisplayTransformation
  class Factory < ItemFactory
    class << self
      alias_method :transformations, :items
      alias_method :transformation_names, :names
      alias_method :transformations=, :items=

      def default_key
        :no_transformation
      end

      private

        def default_items
          {
            default_key => DisplayTransformation::None.new,
            render_link_to_collection: DisplayTransformation::None.new,
            paragraph_heading: DisplayTransformation::None.new,
            paragraph: DisplayTransformation::None.new,
            humanize_edtf: DisplayTransformation::None.new
          }
        end

        def item_class
          DisplayTransformation::Base
        end

        def send_error(error_list)
          raise DisplayTransformation::Error.new(
            "Invalid display transformation(s) in transformation list: #{error_list}"
          )
        end
    end
  end
end
