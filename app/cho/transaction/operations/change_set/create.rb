# frozen_string_literal: true

module Transaction::Operations::ChangeSet
  class Create
    include Dry::Transaction::Operation

    def call(resource)
      change_set_class = change_set_class(resource)
      Success(change_set_class.new(resource))
    end

    private

      def change_set_class(resource)
        Object.const_get("#{resource.class}ChangeSet")
      rescue StandardError
        Valkyrie::ChangeSet
      end
  end
end
