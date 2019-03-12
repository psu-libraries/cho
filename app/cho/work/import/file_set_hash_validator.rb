# frozen_string_literal: true

module Work
  module Import
    class FileSetHashValidator < Csv::HashValidator
      include WithHashCreators

      private

        def validate
          clean_creators
          super
        end

        def clean_creators
          resource_hash['creator'] = agents_with_roles
        end
    end
  end
end
