module Validation
  class ValidatorController < ApplicationController
    skip_authorize_resource only: :index

    def index
      work = params.fetch(:work_submission, nil)
      file_set = params.fetch(:file_set, nil)

      status = validate_params
      render json: { messages: { en: "this is bad" } }, status: 404
    end


    private

      def validate_params
        200
      end

  end
end
