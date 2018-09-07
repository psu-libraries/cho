# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preview of CSV Import', type: :feature do
  let(:collection) { create :library_collection, title: 'my collection' }

  context 'with a valid csv' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        identifier: ['work1', 'work2', 'work3'],
        member_of_collection_ids: [collection.id, collection.id, collection.id],
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', 'My Work 2', 'My Work 3'],
        batch_id: ['batch1_2018-07-12', 'batch1_2018-07-12', 'batch1_2018-07-12']
      )
    end

    let(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batch1_2018-07-12',
        data: {
          work1: ['work1_preservation.tif'],
          work2: ['work2_preservation.tif'],
          work3: ['work3_preservation.tif']
        }
      )
    end

    before do
      ImportFactory::Zip.create(bag)
    end

    it 'successfully imports the csv' do
      visit(csv_create_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_selector('h2', text: 'Bag Status')
      expect(page).to have_selector('h2', text: 'CSV Status')
      expect(page).to have_content('The bag is valid and contains no errors')
      expect(page).to have_content('The following new works will be created')
      expect(page).to have_content('Total Number of Works with Errors 0')
      within('table') do
        expect(page).to have_selector('th', text: 'Title')
        expect(page).to have_selector('th', text: 'Status')
        expect(page).to have_selector('tr', text: 'My Work 1 Success')
        expect(page).to have_selector('tr', text: 'My Work 2 Success')
        expect(page).to have_selector('tr', text: 'My Work 3 Success')
      end
      click_button('Perform Import')
      expect(page).to have_selector('h1', text: 'Successful Import')
      within('ul.result-list') do
        expect(page).to have_selector('li a', text: 'My Work 1')
        expect(page).to have_selector('li a', text: 'My Work 2')
        expect(page).to have_selector('li a', text: 'My Work 3')
      end

      # Verify each work has a file set and a file
      Work::Submission.all.each do |work|
        expect(work.batch_id).to eq('batch1_2018-07-12')
        expect(work.file_set_ids.count).to eq(1)
        file_set = Work::FileSet.find(Valkyrie::ID.new(work.file_set_ids.first))
        expect(file_set.member_ids.count).to eq(1)
        file = Work::File.find(Valkyrie::ID.new(file_set.member_ids.first))
        expect(file_set.title).to contain_exactly(file.original_filename)
        expect(file.original_filename).to eq("#{work.identifier.first}_preservation.tif")
      end
    end
  end

  context 'when the csv has invalid columns' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        member_of_collection_ids: [collection.id, collection.id, collection.id],
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', 'My Work 2', 'My Work 3'],
        batch_id: ['batch1_2018-07-12', 'batch1_2018-07-12', 'batch1_2018-07-12'],
        invalid_column: ['wrong', 'bad', nil]
      )
    end

    it 'does not perform the dry run' do
      visit(csv_create_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      within('div.alert') do
        expect(page).to have_content("Unexpected column(s): 'invalid_column'")
      end
    end
  end

  context 'when the csv has missing values' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        member_of_collection_ids: [nil, collection.id, collection.id],
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', nil, 'My Work 3'],
        batch_id: ['batch1_2018-07-12', 'batch1_2018-07-12', 'batch1_2018-07-12']
      )
    end

    it 'displays the errors in the dry run page' do
      visit(csv_create_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('Total Number of Works with Errors 2')
      within('table.table') do
        expect(page).to have_content("Member of collection ids can't be blank")
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

  context 'with an invalid bag' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        identifier: ['work1', 'work2', 'work3'],
        member_of_collection_ids: [collection.id, collection.id, collection.id],
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', 'My Work 2', 'My Work 3'],
        batch_id: ['batch2_2018-07-12', 'batch2_2018-07-12', 'batch2_2018-07-12']
      )
    end

    let(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batch2_2018-07-12',
        data: {
          work1: ['badId_preservation.tif'],
          work2: ['work2_preservation.tif'],
          work3: ['work3_preservation.tif']
        }
      )
    end

    before do
      ImportFactory::Zip.create(bag)
    end

    it 'displays the bag errors in the dry run page' do
      visit(csv_create_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_content('The bag contains 1 error(s)')
      expect(page).to have_selector(
        'li',
        text: /^Import file badId_preservation.tif does not match the parent directory/
      )
    end
  end
end
