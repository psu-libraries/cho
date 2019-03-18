# frozen_string_literal: true

module Work::WithUseType
  extend ActiveSupport::Concern

  class UseTypes
    def self.call(value)
      raise Dry::Struct::Error, "#{value} is not a valid use type" unless valid?(value)

      value
    end

    def self.valid?(value)
      Repository::FileUse.uris.include?(value)
    end
  end

  included do
    attribute :use, Valkyrie::Types::Set.of(UseTypes).default([Vocab::FileUse.PreservationMasterFile])
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
