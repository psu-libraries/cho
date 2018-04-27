# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::CommonFields, type: :model do
  before(:all) do
    class MyCollection < Valkyrie::Resource
      include Collection::CommonFields
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyCollection')
  end

  subject(:collection) { MyCollection.new }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:workflow) }
  it { is_expected.to respond_to(:visibility) }

  describe '#visibility=' do
    it 'can be set' do
      expect { collection.visibility = 'public' }.not_to raise_error
      expect { collection.visibility = 'authenticated' }.not_to raise_error
      expect { collection.visibility = 'private' }.not_to raise_error
      expect { collection.visibility = 'bogus' }.to raise_error(Dry::Types::ConstraintError)
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
