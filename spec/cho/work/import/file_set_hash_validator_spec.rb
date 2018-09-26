# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::FileSetHashValidator do
  let(:validator) { described_class.new(file_set_hash) }

  describe '#change_set' do
    subject(:change_set) { validator.change_set }

    context 'with a new file set' do
      let(:file_set_hash) do
        {
          'title' => 'My Great File',
          'description' => 'Best description ever.'
        }
      end

      it 'is valid' do
        expect(change_set).to be_a(Work::FileSetChangeSet)
        expect(change_set).to be_valid
        expect(change_set.model).to be_a(Work::FileSet)
        expect(change_set.title).to eq(['My Great File'])
        expect(change_set.description).to eq(['Best description ever.'])
      end
    end

    context 'invalid new file set' do
      let(:file_set_hash) { {} }

      it 'is not valid and has errors' do
        expect(change_set).not_to be_valid
        expect(change_set.errors.full_messages).to eq(["Title can't be blank"])
      end
    end

    context 'with an existing file set' do
      let(:file_set) { create(:file_set) }

      let(:file_set_hash) do
        {
          'id' => file_set.id,
          'title' => 'my awesome updated file_set',
          'description' => 'updated description'
        }
      end

      it 'is valid and has an id' do
        expect(change_set).to be_a(Work::FileSetChangeSet)
        expect(change_set).to be_valid
        expect(change_set.model).to be_a(Work::FileSet)
        expect(change_set.id).to eq(file_set.id)
      end
    end

    context 'with a non-existent file_set' do
      let(:file_set_hash) do
        {
          'id' => 'foo',
          'title' => 'my awesome updated file_set',
          'description' => 'updated description'
        }
      end

      it 'is not valid and has errors' do
        expect(change_set).not_to be_valid
        expect(change_set.errors.full_messages).to eq(['Id does not exist'])
      end
    end
  end
end
