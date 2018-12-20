# frozen_string_literal: true

module Validation
  class Factory < ItemFactory
    class << self
      alias_method :validators, :items
      alias_method :validator_names, :names
      alias_method :validators=, :items=

      def default_key
        :no_validation
      end

      private

        def default_items
          {
            default_key => Validation::None.new,
            resource_exists: Validation::ResourceExists.new,
            edtf_date: Validation::EDTFDate.new,
            creator: Validation::None.new
          }
        end

        def item_class
          Validation::Base
        end

        def send_error(error_list)
          raise Validation::Error.new("Invalid validator(s) in validation list: #{error_list}")
        end
    end
  end
end
