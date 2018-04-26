# frozen_string_literal: true

# Factories in FactoryBot don't return the value returned via `to_create`.
# This custom strategy is necessary to enable data mapper patterns in FactoryBot
#
# Copied from:
#   https://github.com/thoughtbot/factory_bot/issues/565
class CreateStategyForRepositoryPattern
  def association(runner)
    runner.run
  end

  def result(evaluation)
    result = nil
    evaluation.object.tap do |instance|
      evaluation.notify(:after_build, instance)
      evaluation.notify(:before_create, instance)
      result = evaluation.create(instance)
      evaluation.notify(:after_create, result)
    end

    result
  end
end
FactoryBot.register_strategy(:create, CreateStategyForRepositoryPattern)
