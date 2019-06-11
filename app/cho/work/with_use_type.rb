# frozen_string_literal: true

module Work::WithUseType
  extend ActiveSupport::Concern

  included do
    attribute :use, Valkyrie::Types::Set.of(Repository::Types::UseType).default([Vocab::FileUse.PreservationMasterFile])
  end

  Repository::FileUse.uris.each do |uri|
    define_method Repository::FileUse.new(uri.fragment).set_method do
      self.use = [uri]
    end

    define_method Repository::FileUse.new(uri.fragment).ask_method do
      use.include?(uri)
    end
  end
end
