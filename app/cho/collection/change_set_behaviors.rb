# frozen_string_literal: true

module Collection::ChangeSetBehaviors
  extend ActiveSupport::Concern

  included do
    property :title, multiple: false, required: true
    validates :title, presence: true

    property :subtitle, multiple: false, required: false

    property :description, multiple: false, required: false

    property :workflow, multiple: false, required: true
    validates :workflow, inclusion: { in: ::Collection::CommonFields::Workflow }
    validates :workflow, presence: true

    property :visibility, multiple: false, required: true
    validates :visibility, inclusion: { in: ::Collection::CommonFields::Visibility }
    validates :visibility, presence: true
  end
end
