# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preview of CSV Update', type: :feature do
  context 'with a valid csv' do
    let(:csv_file) do
      CsvFactory::Update.new(
        { title: 'My Updated Work 1' },
        { title: 'My Updated Work 2' },
        title: 'My Updated Work 3'
      )
    end

    it 'successfully updates the works' do
      visit(csv_works_update_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      expect(page).to have_content('Import a CSV that updates existing resources')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('The following resources will be updated')
      expect(page).to have_content('Total Number of Resources with Errors 0')
      within('table') do
        expect(page).to have_selector('th', text: 'Title')
        expect(page).to have_selector('th', text: 'Status')
        expect(page).to have_selector('tr', text: 'My Updated Work 1 Success')
        expect(page).to have_selector('tr', text: 'My Updated Work 2 Success')
        expect(page).to have_selector('tr', text: 'My Updated Work 3 Success')
      end
      click_button('Perform Import')
      expect(page).to have_selector('h1', text: 'Successful Import')
      within('ul.result-list') do
        expect(page).to have_selector('li a', text: 'My Updated Work 1')
        expect(page).to have_selector('li a', text: 'My Updated Work 2')
        expect(page).to have_selector('li a', text: 'My Updated Work 3')
      end
    end
  end

  context 'when the csv has a missing id column' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', 'My Work 2', 'My Work 3']
      )
    end

    it 'does not perform the dry run' do
      visit(csv_works_update_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      within('div.alert') do
        expect(page).to have_content('Missing id column for update')
      end
    end
  end

  context 'when the csv has missing values' do
    let(:csv_file) do
      CsvFactory::Update.new(
        { title: 'My Updated Work 1' },
        { title: nil },
        title: 'My Updated Work 3'
      )
    end

    it 'displays the errors in the dry run page' do
      visit(csv_works_update_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('Total Number of Resources with Errors 1')
      within('table.table') do
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

  context 'with works containing file sets' do
    let!(:agent) { create :agent, :generate_name }

    let(:collection) { create(:archival_collection) }

    let(:csv_import_file) do
      CsvFactory::Generic.new(
        alternate_ids: ['work1', 'work1_01', 'work1_02', 'work1_03', 'work1_04'],
        home_collection_id: [collection.id, nil, nil, nil, nil],
        work_type: ['Generic', nil, nil, nil, nil],
        title: ['Work One', 'Page 1', 'Page 2', 'Page 3', 'Page 4'],
        batch_id: (([] << 'batch22_2013-03-13') * 5)
      )
    end

    let(:titles) { ['Work One', 'Page One', 'Page Two', 'Page Three', 'Page Four', 'work1_access.pdf'] }
    let(:missing_titles) { ['Work One', 'Page One', nil, 'Page Three', 'Page Four', 'work1_access.pdf'] }
    let(:dates) { ['2019', '2019', '2019', '2019', '2019', nil] }
    let(:bad_dates) { ['2019', '2019', '2019', 'not a date', '2019', nil] }

    # Create a new csv with updated values for testing
    let(:csv_update_file) do
      matrix = CSV.parse(SolrDocument.find('work1').export_as_csv)

      matrix.each_with_index do |row, i|
        next if i == 0

        row[2] = titles[i - 1]
        row[3] = MetadataFactory.fancy_title
        row[4] = Faker::Lorem.paragraph

        row[6] = if i == 1
                   agent.display_name.to_s
                 else
                   "#{agent.display_name}#{CsvParsing::SUBVALUE_SEPARATOR}cli"
                 end

        row[9] = dates[i - 1]
      end

      Tempfile.open do |csv_file|
        matrix.each { |line| csv_file.write(line.to_csv) }
        csv_file.path
      end
    end

    # Create a new csv with incorrect updated values
    let(:csv_update_file_with_errors) do
      matrix = CSV.parse(SolrDocument.find('work1').export_as_csv)

      matrix.each_with_index do |row, i|
        next if i == 0
        row[2] = missing_titles[i - 1]
        row[6] = [nil, nil, nil, nil, 'Dude, Bad Agent', nil][i - 1]
        row[9] = bad_dates[i - 1]
      end

      Tempfile.open do |csv_file|
        matrix.each { |line| csv_file.write(line.to_csv) }
        csv_file.path
      end
    end

    let(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batch22_2013-03-13',
        data: {
          work1: [
            'work1_01_preservation.tif',
            'work1_01_service.jp2',
            'work1_02_preservation.tif',
            'work1_02_service.jp2',
            'work1_03_preservation.tif',
            'work1_03_service.jp2',
            'work1_04_preservation.tif',
            'work1_04_service.jp2',
            'work1_access.pdf',
            'work1_text.txt',
            'work1_thumb.jpg'
          ]
        }
      )
    end

    before do
      ImportFactory::Zip.create(bag)
      result = Transaction::Operations::Import::Csv.new.call(
        csv_dry_run: Work::Import::CsvDryRun,
        file: csv_import_file.path,
        update: false
      )
      raise StandardError, 'Failed to create test work' if result.failure?
    end

    it 'updates the metadata of the file sets' do
      visit(csv_works_update_path)
      attach_file('csv_file_file', csv_update_file)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('The following resources will be updated')
      expect(page).to have_content('Total Number of Resources with Errors 0')
      within('table') do
        expect(page).to have_selector('th', text: 'Title')
        expect(page).to have_selector('th', text: 'Identifier')
        expect(page).to have_selector('th', text: 'Status')
        expect(page).to have_selector('td', text: 'Work One')
        expect(page).to have_selector('td', text: 'Page One')
        expect(page).to have_selector('td', text: 'Page Two')
        expect(page).to have_selector('td', text: 'Page Three')
        expect(page).to have_selector('td', text: 'Page Four')
      end
      click_button('Perform Import')
      expect(page).to have_selector('h1', text: 'Successful Import')

      # Verify metadata updates
      work = SolrDocument.find('work1')
      expect(work['creator_tesim']).to contain_exactly(agent.display_name)
      expect(work['creator_role_ssim']).to be_nil
      expect(work.file_sets.map(&:title).flatten).to contain_exactly(
        'Page Four', 'Page One', 'Page Three', 'Page Two'
      )
      expect(work.file_sets.map(&:created).flatten.uniq.compact).to contain_exactly('2019')
      expect(work.file_sets.map(&:creator).flatten.uniq.first).to eq(
        role: 'http://id.loc.gov/vocabulary/relators/cli', agent: agent.id.to_s
      )
    end

    it "displays errors in the file sets' metadata" do
      visit(csv_works_update_path)
      attach_file('csv_file_file', csv_update_file_with_errors)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('The following resources will be updated')
      expect(page).to have_content('Total Number of Resources with Errors 3')
      within('table') do
        expect(page).to have_selector('td', text: "Title can't be blank")
        expect(page).to have_selector('td', text: 'Created Date not a date is not a valid EDTF date')
        expect(page).to have_selector('td', text: "Creator agent 'Dude, Bad Agent' does not exist")
      end
    end
  end
end
