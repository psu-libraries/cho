# frozen_string_literal: true

module ValkyrieControllerBehaviors
  def load_change_set
    change_set_class.new(find_resource(params[:id])).prepopulate!
  end

  def initialize_change_set(**args)
    change_set_class.new(resource_class.new(args)).prepopulate!
  end

  def validate_save_and_respond(change_set, error_view)
    updated_change_set = change_set_persister.validate_and_save(
      change_set: change_set,
      resource_params: resource_params
    )
    if updated_change_set.errors.blank?
      respond_success(updated_change_set)
    else
      respond_error(updated_change_set, error_view)
    end
  end

  def change_set_class
    raise StandardError.new('This needs to be define in the class including this module')
  end

  def resource_class
    raise StandardError.new('This needs to be define in the class including this module')
  end

  def destroy_item(url, notice)
    persister.delete(resource: delete_change_set.resource)
    respond_to do |format|
      format.html { redirect_to url, notice: notice }
      format.json { head :no_content }
    end
  end

  private

    def respond_success(change_set)
      view_data(change_set)
      respond_to do |format|
        format.html do
          redirect_to change_set.resource, notice: success_message
        end
        format.json { render :show, status: :ok, location: change_set.resource }
      end
    end

    def respond_error(change_set, error_view)
      view_data(change_set)
      respond_to do |format|
        format.html { render error_view }
        format.json { render json: change_set.errors, status: :unprocessable_entity }
      end
    end

    def find_resource(id)
      resource_class.find(Valkyrie::ID.new(id))
    end

    def change_set_persister
      @change_set_persister ||= ChangeSetPersister.new(
        metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
        storage_adapter: Valkyrie.config.storage_adapter
      )
    end

    def delete_change_set
      raise StandardError.new('This needs to be define in the class including this module')
    end

    def persister
      raise StandardError.new('This needs to be define in the class including this module')
    end

    def view_data(_change_set)
      raise StandardError.new('This needs to be define in the class including this module')
    end

    def success_message
      raise StandardError.new('This needs to be define in the class including this module')
    end
end
