# frozen_string_literal: true

module Agent
  class ChangeSet < Valkyrie::ChangeSet
    property :given_name, multiple: false, required: true
    validates :given_name, presence: true

    property :surname, multiple: false, required: true
    validates :surname, presence: true
  end
end
