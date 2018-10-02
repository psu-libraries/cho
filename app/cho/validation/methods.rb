# frozen_string_literal: true

# @note this is a module outside the scope of Validation::Factory, and is used to hold the
#   ActiveModel-type validations used on change sets. See https://github.com/psu-libraries/cho/issues/672
module Validation::Methods
  def no_validation(field)
    # noop
  end

  def resource_exists(field)
    return if self[field].blank?
    member = Validation::Member.new(self[field])
    errors.add(field, "#{member.id} does not exist") unless member.exists?
  end
end
