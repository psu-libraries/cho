# frozen_string_literal: true

module Repository::Types
  include Dry::Types.module

  UseType = Dry::Types::Definition
    .new(RDF::URI)
    .constructor do |input|
    raise Dry::Struct::Error, "#{input} is not a valid use type" unless Repository::FileUse.uris.include?(input)

    input
  end
end
