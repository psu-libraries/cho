# frozen_string_literal: true

module DataDictionary::WithIndexType
  extend ActiveSupport::Concern

  IndexTypes = Valkyrie::Types::String.enum('facet', 'no_facet', 'date')

  included do
    attribute :index_type, IndexTypes
  end

  def facet!
    self.index_type = 'facet'
  end

  def facet?
    index_type == 'facet'
  end

  def no_facet!
    self.index_type = 'no_facet'
  end

  def no_facet?
    index_type == 'no_facet'
  end

  def date!
    self.index_type = 'date'
  end

  def date?
    index_type == 'date'
  end
end
