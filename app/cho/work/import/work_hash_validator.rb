# frozen_string_literal: true

# Validates a work hash using the Work::SubmissionChangeSet
#
# @example resource_hash
#    {'member_of_collection_ids'=>'abc-123', 'work_type_id'=>'def-222', 'title'=>'my awesome work', 'description'=> ''}
module Work
  module Import
    class WorkHashValidator < Csv::HashValidator
      private

        def validate
          clean_hash
          super
        end

        def clean_hash
          resource_hash['member_of_collection_ids'] = collection_ids
          resource_hash['creator'] = agents_with_roles
          unless updating? || work_type.blank?
            resource_hash['work_type_id'] = work_type.id
          end
        end

        def work_type
          @work_type ||= begin
                           label = resource_hash.fetch('work_type', nil)
                           label = label.downcase.titleize if label.present?
                           Work::Type.find_using(label: label).first
                         end
        end

        def collection_ids
          Array.wrap(resource_hash['member_of_collection_ids']).map do |id|
            psu_id_to_collection_id(id)
          end
        end

        def psu_id_to_collection_id(id)
          Valkyrie.config.metadata_adapter.query_service.find_by_alternate_identifier(alternate_identifier: id).id
        rescue Valkyrie::Persistence::ObjectNotFoundError
          id
        end

        def agents_with_roles
          Array.wrap(resource_hash['creator']).map do |creator|
            fullname, role = creator.split(CsvParsing::SUBVALUE_SEPARATOR)
            {
              role: find_role(role),
              agent: find_agent(fullname)
            }
          end
        end

        def find_agent(name)
          surname, given_name = name.split(Agent::Resource::NAME_SEPARATOR)
          result = Agent::Resource.where(given_name: given_name.strip, surname: surname.strip).first
          if result
            result.id.to_s
          else
            name
          end
        end

        def find_role(role)
          return if role.blank?
          RDF::URI("http://id.loc.gov/vocabulary/relators/#{role}")
        end
    end
  end
end
