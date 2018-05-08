# frozen_string_literal: true

module Postgres
  class SingularPersister < Valkyrie::Persistence::Postgres::Persister
    private

      # overriding ensure_multiple_values! to do nothing since we are allowing singular values
      def ensure_multiple_values!(resource); end
  end
end
