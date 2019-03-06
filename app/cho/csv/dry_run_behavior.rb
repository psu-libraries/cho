# frozen_string_literal: true

module Csv::DryRunBehavior
  attr_reader :update, :reader

  def update?
    update
  end

  def bag
    Dry::Monads::Result::Failure.new('This dry run class does not implement bags')
  end

  private

    def validate_structure
      raise Csv::ValidationError, "Unexpected column(s): '#{invalid_fields.join(', ')}'" if invalid_fields.present?

      if update?
        raise Csv::ValidationError, 'Missing id column for update' unless reader.headers.include?('id')
      end
    end
end
