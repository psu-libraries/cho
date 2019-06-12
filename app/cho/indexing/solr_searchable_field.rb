# frozen_string_literal: true

module Indexing
  class SolrSearchableField
    attr_reader :field

    def initialize(dd_field)
      raise ArgumentError, 'Please provide a DataDictionary::Field or similar interface' unless dd_field?(dd_field)

      @field = dd_field
    end

    delegate :label, to: :field

    def solr_search_params
      {
        qf: qf,
        pf: pf
      }
    end

    def qf
      fields = ["#{label}_tesim"]
      fields << "#{label}_dtrsim" if edtf_date?

      fields.join(' ')
    end

    def pf
      qf
    end

    private

      def dd_field?(dd_field)
        %i[label date? validation].all? { |m| dd_field.respond_to?(m) }
      end

      def edtf_date?
        field.validation == 'edtf_date'
      end
  end
end
