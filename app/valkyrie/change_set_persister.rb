# frozen_string_literal: true

# @note This takes the the class from the Valkyrie MVP app and adds #buffer_into_index so that
# we can use {IndexingAdapter} and store in Postgres while indexing in Solr at the same time.
# @todo Includes a lot of commented-out methods dealing with adding files, and updating/deleting
# parent objects. These could be used later, so they're being left here for possible future
# implementation.
# @see https://github.com/samvera-labs/valkyrie/blob/master/app/change_set_persisters/change_set_persister.rb
class ChangeSetPersister
  attr_reader :metadata_adapter, :storage_adapter
  delegate :persister, :query_service, to: :metadata_adapter
  def initialize(metadata_adapter:, storage_adapter:)
    @metadata_adapter = metadata_adapter
    @storage_adapter = storage_adapter
  end

  # @note uses a simple save method instead of the commented-out original version
  # @todo Enable #before_save and #after_save methods to manage files and parent works
  def save(change_set:)
    # before_save(change_set: change_set)
    # persister.save(resource: change_set.resource).tap do |output|
    #   after_save(change_set: change_set, updated_resource: output)
    # end
    persister.save(resource: change_set.resource)
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

  # @todo Enable methods to delete parent works
  def delete(change_set:)
    # before_delete(change_set: change_set)
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

  # @note these are all private methods in the original.

  # def before_save(change_set:)
  #   create_files(change_set: change_set)
  # end

  # def after_save(change_set:, updated_resource:)
  #   append(append_id: change_set.append_id, updated_resource: updated_resource) if change_set.append_id
  # end

  # def append(append_id:, updated_resource:)
  #   parent_obj = query_service.find_by(id: append_id)
  #   parent_obj.member_ids = parent_obj.member_ids + [updated_resource.id]
  #   persister.save(resource: parent_obj)
  # end

  # @see https://github.com/samvera-labs/valkyrie/blob/master/app/services/file_appender.rb
  # def create_files(change_set:)
  #   appender = FileAppender.new(storage_adapter: storage_adapter, persister: persister, files: files(change_set: change_set))
  #   appender.append_to(change_set.resource)
  # end

  # def files(change_set:)
  #   change_set.try(:files) || []
  # end

  # def before_delete(change_set:)
  #   parents = query_service.find_parents(resource: change_set.resource)
  #   parents.each do |parent|
  #     parent.member_ids -= [change_set.id]
  #     persister.save(resource: parent)
  #   end
  # end
end
