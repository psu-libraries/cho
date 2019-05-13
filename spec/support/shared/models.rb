# frozen_string_literal: true

RSpec.shared_examples 'a resource with Valkyrie::Resource::AccessControls' do
  before do
    raise 'resource_klass must be set with `let(:resource_klass)`' unless
      defined? resource_klass
  end

  describe '#read_groups' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(read_groups: ['one', 'two'])
      expect(resource.read_groups).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.read_groups).to be_empty
    end

    describe '#has_attribute?' do
      it 'returns true when it has a given attribute' do
        resource = resource_klass.new
        expect(resource.has_attribute?(:read_groups)).to eq true
      end
    end

    describe '#fields' do
      it 'returns a set of fields' do
        expect(resource_klass).to respond_to(:fields).with(0).arguments
        expect(resource_klass.fields).to include(:read_groups)
      end
    end

    describe '#attributes' do
      it 'returns a list of all set attributes' do
        resource = resource_klass.new(read_groups: ['one', 'two'])
        expect(resource.attributes[:read_groups]).to eq ['one', 'two']
      end
    end
  end

  describe '#read_users' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(read_users: ['one', 'two'])
      expect(resource.read_users).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.read_users).to be_empty
    end

    describe '#has_attribute?' do
      it 'returns true when it has a given attribute' do
        resource = resource_klass.new
        expect(resource.has_attribute?(:read_users)).to eq true
      end
    end

    describe '#fields' do
      it 'returns a set of fields' do
        expect(resource_klass).to respond_to(:fields).with(0).arguments
        expect(resource_klass.fields).to include(:read_users)
      end
    end

    describe '#attributes' do
      it 'returns a list of all set attributes' do
        resource = resource_klass.new(read_users: ['one', 'two'])
        expect(resource.attributes[:read_users]).to eq ['one', 'two']
      end
    end
  end

  describe '#edit_users' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(edit_users: ['one', 'two'])
      expect(resource.edit_users).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.edit_users).to be_empty
    end

    describe '#has_attribute?' do
      it 'returns true when it has a given attribute' do
        resource = resource_klass.new
        expect(resource.has_attribute?(:edit_users)).to eq true
      end
    end

    describe '#fields' do
      it 'returns a set of fields' do
        expect(resource_klass).to respond_to(:fields).with(0).arguments
        expect(resource_klass.fields).to include(:edit_users)
      end
    end

    describe '#attributes' do
      it 'returns a list of all set attributes' do
        resource = resource_klass.new(edit_users: ['one', 'two'])
        expect(resource.attributes[:edit_users]).to eq ['one', 'two']
      end
    end
  end

  describe '#edit_groups' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(edit_groups: ['one', 'two'])
      expect(resource.edit_groups).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.edit_groups).to be_empty
    end

    describe '#has_attribute?' do
      it 'returns true when it has a given attribute' do
        resource = resource_klass.new
        expect(resource.has_attribute?(:edit_groups)).to eq true
      end
    end

    describe '#fields' do
      it 'returns a set of fields' do
        expect(resource_klass).to respond_to(:fields).with(0).arguments
        expect(resource_klass.fields).to include(:edit_groups)
      end
    end

    describe '#attributes' do
      it 'returns a list of all set attributes' do
        resource = resource_klass.new(edit_groups: ['one', 'two'])
        expect(resource.attributes[:edit_groups]).to eq ['one', 'two']
      end
    end
  end
end
