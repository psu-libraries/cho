# frozen_string_literal: true

require 'csv'

# This module provide CSV export for works and collections
#  @note the collection export is a list of works in CSV format, not the collection metadata
#
module Document::Csv
  include CsvParsing

  def self.extended(document)
    # Register our exportable formats
    Document::Csv.register_export_formats(document)
  end

  def self.register_export_formats(document)
    document.will_export_as(:csv)
  end

  # Export the currect solr document in csv format
  def export_as_csv
    if collection?
      export_collection
    else
      export_model
    end
  end

  # needed to use the solr document as a scope for a search builder
  def resource
    self
  end

  # needed to use the solr document as a scope for a search builder
  def blacklight_config
    CatalogController.blacklight_config
  end

  private

    def export_collection
      ::CSV.generate do |csv|
        csv << ['id', 'member_of_collection_ids'] + fields.map(&:label)
        export_members(csv)
      end
    end

    def export_model
      ::CSV.generate { |csv| csv << export_fields(self) }
    end

    def export_members(csv)
      page = 1
      more_members = true
      while more_members
        members = document_facade(page).members
        members.each do |member|
          csv << export_fields(member)
        end
        page += 1
        more_members = members.count >= rows
      end
    end

    def export_fields(solr_document)
      values = fields.map do |field|
        to_csv_field(solr_document.send(field.method_name))
      end
      [solr_document.id, to_csv_field(solr_document['member_of_collection_ids_ssim'])].concat(values)
    end

    def fields
      @fields ||= load_fields
    end

    # cleans up ids and converts arrays to a single string
    def to_csv_field(field_value)
      return field_value if field_value.blank?
      remove_id_marker(Array.wrap(field_value)).join(VALUE_SEPARATOR)
    end

    # removes id- that gets added to the id fields in solr documents
    def remove_id_marker(field_value)
      field_value.map { |value| value.sub(/^id-/, '') }
    end

    def document_facade(current_page = 1)
      SolrFacade.new(
        repository: Blacklight.default_index,
        query: CollectionMemberSearchBuilder.new(self).page(current_page).rows(rows).query
      )
    end

    def rows
      100
    end

    def load_fields
      sorted_fields = DataDictionary::Field.all.sort_by { |a, _b| a.created_at }
      sorted_fields.sort do |a, b|
        if a.core_field & b.core_field
          0
        elsif a.core_field
          -1
        elsif b.core_field
          1
        else
          a.label <=> b.label
        end
      end
    end
end
