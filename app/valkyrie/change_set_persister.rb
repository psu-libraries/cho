# frozen_string_literal: true

# Based on a class from the original Valkyrie MVP app. Provides the ability to use the {IndexingAdapter}
# and store in Postgres while indexing in Solr at the same time.
class ChangeSetPersister
  attr_reader :metadata_adapter, :storage_adapter
  delegate :persister, :query_service, to: :metadata_adapter
  def initialize(metadata_adapter:, storage_adapter:)
    @metadata_adapter = metadata_adapter
    @storage_adapter = storage_adapter
  end

  def save(change_set:)
    persister.save(resource: change_set.resource)
  end

  def update_or_create(resource, unique_attribute: nil, unique_attributes: nil)
    unique_attributes ||= [unique_attribute]
    attribute_values = {}
    unique_attributes.each do |attribute|
      attribute_values[attribute] = resource.send(attribute)
    end

    additional_attributes = {}
    if resource.class.where(attribute_values).count.positive?
      additional_attributes = resource.attributes.merge(new_record: false)
      resource = resource.class.where(attribute_values).first
    end

    result = Transaction::Shared::SaveWithResource.new
      .with_step_args(validate: [additional_attributes: additional_attributes],
                      save: [persister: persister])
      .call(resource)
    result.success
  end

  def validate_and_save(change_set: nil, resource_params:)
    result = Transaction::Shared::SaveWithChangeSet.new
      .with_step_args(validate: [additional_attributes: resource_params],
                      save: [persister: persister])
      .call(change_set)
    if result.success?
      change_set.class.new(result.success)
    else
      result.failure
    end
  rescue StandardError => error
    change_set.errors.add(:save, error.message)
    change_set
  end

  def delete(change_set:)
    delete_members(change_set.resource)
    update_membership(change_set.resource)
    persister.delete(resource: change_set.resource)
  rescue StandardError => e
    change_set.errors.add(:delete, e.message)
    change_set
  end

  def save_all(change_sets:)
    change_sets.map do |change_set|
      save(change_set: change_set)
    end
  end

  private

    def delete_members(resource)
      return unless resource.try(:member_ids)
      resource.member_ids.each do |member_id|
        member = Valkyrie.config.metadata_adapter.query_service.find_by(id: member_id)
        delete_members(member)
        FileUtils.rm(member.path) if member.is_a?(Work::File)
        persister.delete(resource: member)
      end
    end

    def update_membership(resource)
      query_service.find_inverse_references_by(resource: resource, property: 'member_ids').each do |parent|
        parent.member_ids.delete(resource.id)
        persister.save(resource: parent)
      end
    end
end
