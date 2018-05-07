# frozen_string_literal: true

class Solr::SingularRepository < Valkyrie::Persistence::Solr::Repository
  # overriding ensure_multiple_values! to do nothing since we are allowing singular values
  def ensure_multiple_values!(resource); end
end
