# frozen_string_literal: true

# Queries solr for documents that assert a collection membership relationship to another document.
# @note This was copied from Figgy to enable display of works within a collection's show page.
class CollectionMemberSearchBuilder < ::SearchBuilder
  class_attribute :collection_membership_field
  self.collection_membership_field = 'home_collection_id_ssim'
  self.default_processor_chain += [:home_collection_id]

  def home_collection_id(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "#{collection_membership_field}:id-#{collection_id}"
  end

  private

    def collection_id
      @scope.resource.id || raise('Collection does not have an identifier')
    end
end
