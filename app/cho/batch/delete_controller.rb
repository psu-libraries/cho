# frozen_string_literal: true

module Batch
  class DeleteController < ApplicationController
    include ValkyrieControllerBehaviors

    # @note Defines a generic change set that can be used with any resource, solely for the purpose
    #       of deleting it.
    DeleteSet = Struct.new(:resource)

    # @note Keeps all the batch views together in the same directory
    def self._prefixes
      super + ['batch']
    end

    # POST /batch/delete
    def confirm
      @resources = resources
    end

    # DELETE /batch/delete
    def destroy
      resources.each do |resource|
        change_set_persister.delete(change_set: DeleteSet.new(resource))
      end
      flash[:success] = t('cho.batch.delete.success', list: resources.map(&:title).flatten.join(', '))
      redirect_to(search_select_path)
    end

    private

      def ids
        return [] unless params.key?(:delete)
        params[:delete].to_unsafe_h.fetch(:ids, [])
      end

      # @todo use Valkyrie::Persistence::Postgres.find_many_by_ids after we upgrade to 1.0
      def resources
        @resources ||= ids.map do |id|
          change_set_persister.metadata_adapter.query_service.find_by(id: Valkyrie::ID.new(id))
        end
      end
  end
end
