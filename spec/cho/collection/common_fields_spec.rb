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

  subject { MyCollection.new }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:subtitle) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:workflow) }
  it { is_expected.to respond_to(:visibility) }
end
