# frozen_string_literal: true

class WorkObject < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls
  include BaseMAP
  attribute :id, Valkyrie::Types::ID.optional
  attribute :work_type, Valkyrie::Types::Set
end
