# frozen_string_literal: true

class Memory::SingularPersister < Valkyrie::Persistence::Memory::Persister
  # overriding ensure_multiple_values! to do nothing since we are allowing singular values
  def ensure_multiple_values!(resource); end
end
