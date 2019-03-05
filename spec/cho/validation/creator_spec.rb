# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::Creator, type: :model do
  describe '#validate' do
    subject { validation_instance.validate(creators) }

    let(:validation_instance) { described_class.new }
    let(:agent) { create(:agent) }

    context 'with an existing agent and role' do
      let(:creators) { { role: MockRDF.relators.first.to_uri.to_s, agent: agent.id } }

      specify do
        expect(validation_instance.validate(creators)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with multiple existing agents and roles' do
      let(:creators) do
        [
          { role: MockRDF.relators.first.to_uri.to_s, agent: agent.id },
          { role: MockRDF.relators.last.to_uri.to_s, agent: agent.id }
        ]
      end

      specify do
        expect(validation_instance.validate(creators)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with an agent and no role' do
      let(:creators) { { role: '', agent: agent.id } }

      specify do
        expect(validation_instance.validate(creators)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with a nil value' do
      let(:creators) { {} }

      specify do
        expect(validation_instance.validate(creators)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with an empty value' do
      let(:creators) { '' }

      specify do
        expect(validation_instance.validate(creators)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with blank values' do
      let(:creators) { { role: '', agent: '' } }

      specify do
        expect(validation_instance.validate(creators)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'when the value is not a hash' do
      let(:creators) { 'Joe Smith' }

      specify do
        expect(validation_instance.validate(creators)).to be_falsey
        expect(validation_instance.errors).to contain_exactly(
          "agent 'Joe Smith' does not exist",
          "role 'Joe Smith' does not exist"
        )
      end
    end

    context 'when the required keys are missing' do
      let(:creators) { { not_roll: 'author', not_agent: 'Smith, John' } }

      specify do
        expect(validation_instance.validate(creators)).to be_falsey
        expect(validation_instance.errors).to contain_exactly('must contain an agent and a role')
      end
    end

    context 'when the role does not exist' do
      let(:creators) { { role: 'curler', agent: agent.id } }

      specify do
        expect(validation_instance.validate(creators)).to be_falsey
        expect(validation_instance.errors).to contain_exactly("role 'curler' does not exist")
      end
    end

    context 'when the agent does not exist' do
      let(:creators) { { role: '', agent: 'Smith, Joe' } }

      specify do
        expect(validation_instance.validate(creators)).to be_falsey
        expect(validation_instance.errors).to contain_exactly("agent 'Smith, Joe' does not exist")
      end
    end

    context 'with multiple missing agents and roles' do
      let(:creators) do
        [
          { role: 'faker', agent: agent.id },
          { role: MockRDF.relators.last.to_uri.to_s, agent: 'Mr. Magoo' }
        ]
      end

      specify do
        expect(validation_instance.validate(creators)).to be_falsey
        expect(validation_instance.errors).to contain_exactly(
          "role 'faker' does not exist",
          "agent 'Mr. Magoo' does not exist"
        )
      end
    end
  end
end
