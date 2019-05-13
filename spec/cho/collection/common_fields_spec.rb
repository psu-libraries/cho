# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::CommonFields, type: :model do
  subject(:collection) { MyCollection.new }

  before(:all) do
    class MyCollection < Valkyrie::Resource
      include Collection::CommonFields
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyCollection')
  end

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:workflow) }
  it { is_expected.to respond_to(:access_level) }

  describe '#access_level=' do
    it 'can be set' do
      expect { collection.access_level = 'public' }.not_to raise_error
      expect { collection.access_level = 'authenticated' }.not_to raise_error
      expect { collection.access_level = 'private' }.not_to raise_error
      expect { collection.access_level = 'bogus' }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe '#workflow' do
    it 'can be set' do
      expect { collection.workflow = 'default' }.not_to raise_error
      expect { collection.workflow = 'mediated' }.not_to raise_error
      expect { collection.workflow = 'bogus' }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
