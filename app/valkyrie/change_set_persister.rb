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

  def update_or_create(resource, unique_attribute:)
    attribute_value = resource.send(unique_attribute)
    return resource.class.where(unique_attribute => attribute_value).first if resource.class.where(label: attribute_value).count.positive?
    save(change_set: Valkyrie::ChangeSet.new(resource))
  end

  def validate_and_save(change_set:, resource_params:)
    return change_set unless change_set.validate(resource_params)
    change_set = store_files(change_set)
    change_set.sync
    change_set.class.new(persister.save(resource: change_set))
  rescue StandardError => error
    change_set.errors.add(:save, error.message)
    change_set
  end

  def delete(change_set:)
    before_delete(change_set: change_set)
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

  def buffer_into_index
    metadata_adapter.persister.buffer_into_index do |buffered_adapter|
      yield(buffered_adapter.persister)
    end
  end

  def validate_and_save_with_buffer(change_set:, resource_params:)
    return change_set unless change_set.validate(resource_params)
    change_set = store_files(change_set)
    change_set.sync
    obj = nil
    buffer_into_index do |buffered_changeset_persister|
      obj = buffered_changeset_persister.save(resource: change_set)
    end
    change_set.class.new(obj)
  rescue StandardError => error
    change_set.errors.add(:save, error.message)
    change_set
  end

  private

    def store_files(change_set)
      return change_set unless change_set.respond_to?(:file) && change_set.file.present?
      adapter_file = storage_adapter.upload(file: change_set.file.tempfile, original_filename: change_set.file.original_filename, resource: change_set.model)
      work_file = Work::File.new(file_identifier: adapter_file.id, original_filename: change_set.file.original_filename, use: [Valkyrie::Vocab::PCDMUse.OriginalFile])
      saved_work_file = persister.save(resource: work_file)
      change_set.model.files << saved_work_file.id
      change_set
    end

    def before_delete(change_set:)
      return unless change_set.resource.try(:files)
      change_set.resource.files.each do |file_id|
        delete_file(resource: Work::File.find(file_id))
      end
    end

    def delete_file(resource:)
      FileUtils.rm(resource.path)
      persister.delete(resource: resource)
    end
end
