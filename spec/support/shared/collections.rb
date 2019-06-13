# frozen_string_literal: true

RSpec.shared_examples 'a collection' do
  describe '#title' do
    it 'is nil when not set' do
      expect(resource_klass.new.title).to be_empty
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(title: 'test')
      expect(resource.attributes[:title]).to contain_exactly('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:title)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:title)
    end
  end

  describe '#members' do
    subject { resource_klass.new(new_record: false) }

    its(:members) { is_expected.to be_empty }
  end

  describe '#alternate_ids' do
    context 'when an arbitrary value' do
      let(:resource) { resource_klass.new(alternate_ids: ['abc123']) }

      it 'casts values to Valkyrie IDs' do
        expect(resource.alternate_ids).to include(kind_of(Valkyrie::ID))
        expect(resource.alternate_ids.map(&:to_s)).to eq(['abc123'])
      end
    end

    context 'with a null value' do
      subject { resource_klass.new(alternate_ids: []) }

      its(:alternate_ids) { is_expected.to be_empty }
    end

    context 'by default' do
      subject { resource_klass.new }

      its(:alternate_ids) { is_expected.to be_empty }
    end
  end
end

RSpec.shared_examples 'a collection editable only by admins' do
  context 'when the current user is an admin' do
    it 'shows the edit button' do
      visit(polymorphic_path([:solr_document], id: collection.id))

      within('ul.nav') { expect(page).to have_link('Edit') }
    end
  end

  context 'when the current user is from PSU, but not an admin', :with_psu_user do
    it 'disables the edit link' do
      visit(polymorphic_path([:solr_document], id: collection.id))

      within('ul.nav') { expect(page).not_to have_link('Edit') }
    end
  end

  context 'when the current user is a member of the public', :with_public_user do
    it 'disables the edit link' do
      visit(polymorphic_path([:solr_document], id: collection.id))

      within('ul.nav') { expect(page).not_to have_link('Edit') }
    end
  end
end
