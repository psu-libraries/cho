# frozen_string_literal: true

# Commenting out the collections with resources until collection landing pages are complete
#
# RSpec.shared_examples 'a collection with works' do
#   before do
#     (1..20).each do |count|
#       create(:work, title: "Work #{count}", home_collection_id: [collection.id])
#     end
#   end
#
#   it 'displays a paginated listing of its works' do
#     visit(polymorphic_path([:solr_document], id: collection.id))
#     expect(page).to have_content('Resources in this Collection')
#     within('div#members') do
#       expect(page).to have_link('Work 1')
#       expect(page).not_to have_link('Work 20')
#     end
#     within('div.pagination') do
#       expect(page).to have_link('2')
#       click_link('Next')
#     end
#     within('div#members') do
#       expect(page).not_to have_link('Work 5')
#       expect(page).to have_link('Work 20')
#     end
#   end
# end

RSpec.shared_examples 'a collection with a landing page' do
  it 'has a title' do
    visit(polymorphic_path([:solr_document], id: collection.id))
    expect(page).to have_selector('h1')
    expect(page).to have_selector('p')
    expect(page).to have_selector('dt')
  end
end

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
      expect(page).to have_selector('input[type=submit][value=Edit]')
    end
  end

  context 'when the current user is from PSU, but not an admin', :with_psu_user do
    it 'disables the edit link' do
      visit(polymorphic_path([:solr_document], id: collection.id))

      expect(page).not_to have_selector('input[type=submit][value=Edit]')
    end
  end

  context 'when the current user is a member of the public', :with_public_user do
    it 'disables the edit link' do
      visit(polymorphic_path([:solr_document], id: collection.id))

      expect(page).not_to have_selector('input[type=submit][value=Edit]')
    end
  end
end
