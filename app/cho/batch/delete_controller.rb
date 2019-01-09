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
      presenters
    end

    # DELETE /batch/delete
    def destroy
      presenters.each do |presenter|
        change_set_persister.delete(change_set: DeleteSet.new(presenter.resource))
      end
      flash[:success] = t('cho.batch.delete.success', list: presenters.map(&:confirmation_title).flatten.join(', '))
      redirect_to(search_select_path)
    end

    private

      def ids
        return [] unless params.key?(:delete)

        params[:delete].to_unsafe_h.fetch(:ids, [])
      end

      def presenters
        @presenters ||= resources.map do |resource|
          DeletePresenter.new(resource)
        end
      end

      def resources
        change_set_persister.metadata_adapter.query_service.find_many_by_ids(ids: ids)
      end
  end
end
