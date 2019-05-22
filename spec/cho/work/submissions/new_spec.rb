# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Submission, type: :feature do
  context 'when no work type is provided' do
    it 'redirects to the home page with an error' do
      visit(new_work_path)
      expect(page).to have_content('You must specify a work type')
    end
  end

  context 'when filling in all the fields' do
    let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection') }
    let!(:agent) { create(:agent, given_name: 'Christopher', surname: 'Kringle') }

    it 'creates a new work object without a file' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource')
      fill_in('work_submission[title]', with: 'New Title')
      fill_in('work_submission[subtitle][]', with: 'New subtitle')
      fill_in('work_submission[description][]', with: 'Description of new generic work.')
      fill_in('work_submission[alternate_ids][]', with: 'asdf_1234')
      fill_in('work_submission[generic_field][]', with: 'Sample generic field value')
      fill_in('work_submission[created][]', with: '2018-10-22')
      fill_in('work_submission[home_collection_id]', with: archival_collection.id)
      fill_in('work_submission[creator][][role]', with: MockRDF.relators.first)
      fill_in('work_submission[creator][][agent]', with: agent.id)
      click_button('Create Resource')
      expect(page).to have_selector('h1', text: 'New Title')
      within('#document') do
        expect(page).to have_blacklight_label(:title_tesim)
        expect(page).to have_blacklight_field(:title_tesim, 'New Title')
        expect(page).to have_blacklight_label(:subtitle_tesim)
        expect(page).to have_blacklight_field(:subtitle_tesim, 'New subtitle')
        expect(page).to have_blacklight_label(:description_tesim)
        expect(page).to have_blacklight_field(:description_tesim, 'Description of new generic work')
        expect(page).to have_blacklight_label(:created_tesim)
        expect(page).to have_blacklight_field(:created_tesim, 'datetime-2018-10-22T00:00:00.000Z')
        expect(page).to have_blacklight_label(:generic_field_tesim)
        expect(page).to have_blacklight_field(:generic_field_tesim, 'Sample generic field value')
        expect(page).to have_blacklight_label(:alternate_ids_tesim)
        expect(page).to have_blacklight_field(:alternate_ids_tesim, 'id-asdf_1234')
        expect(page).to have_blacklight_label(:work_type_ssim)
        expect(page).to have_blacklight_field(:work_type_ssim, 'Generic')
        expect(page).to have_blacklight_label(:home_collection_id_tesim)
        expect(page).to have_blacklight_field(:home_collection_id_tesim, 'Sample Collection')
        expect(page).to have_blacklight_field(:home_collection_id_tesim, archival_collection.id)
        expect(page).to have_link('Sample Collection')
        expect(page).to have_blacklight_label(:creator_tesim)
        expect(page).to have_blacklight_field(:creator_tesim, 'Christopher Kringle (climbing)')
      end
      expect(page).to have_selector('input[type=submit][value=Edit]')
    end
  end

  context 'missing or incorrect metadata' do
    let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection') }

    it 'reports the errors' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Document')
      expect(page).to have_content('New Document Resource')
      click_button('Create Resource')
      within('.error-explanation') do
        expect(page).to have_selector('h2', text: '2 errors prohibited this resource from being saved:')
        expect(page).to have_css('ul li', text: "can't be blank", count: 2)
      end
      fill_in('work_submission[title]', with: 'Required Title')
      fill_in('work_submission[home_collection_id]', with: archival_collection.id)
      click_button('Create Resource')
      expect(page).to have_content('Required Title')
      expect(page).to have_content('Document')
      expect(page).to have_selector('input[type=submit][value=Edit]')
    end
  end

  context 'with a non-existent work type' do
    it 'reports the error in the form' do
      visit(new_work_path(work_type_id: 'bogus-work-type-id'))
      expect(page).to have_content('Unable to find resource type')
    end
  end

  context 'when attaching a file' do
    let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection with Files') }

    it 'creates a new work object with a file' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource')
      fill_in('work_submission[title]', with: 'New Title')
      fill_in('work_submission[home_collection_id]', with: archival_collection.id)
      attach_file('File Selection', Pathname.new(fixture_path).join('hello_world.txt'))
      click_button('Create Resource')
      expect(page).to have_content('New Title')
      expect(page).to have_content('Generic')
      expect(page).to have_selector('input[type=submit][value=Edit]')
      expect(page).to have_selector('h2', text: 'Parts')
      expect(page).to have_content('hello_world.txt')
    end
  end

  context 'when attaching a simple zip file to the work' do
    let!(:archival_collection) { create(:archival_collection, title: 'Collection with zipped work') }

    let(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batch1_2018-09-10',
        data: {
          work1: ['work1_preservation.tif']
        }
      )
    end

    let(:zip_file) { ImportFactory::Zip.create(bag) }

    it 'creates a new work object with files from zip' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource')
      fill_in('work_submission[title]', with: 'Work with attached zip')
      fill_in('work_submission[home_collection_id]', with: archival_collection.id)
      attach_file('File Selection', zip_file)
      click_button('Create Resource')
      expect(page).to have_content('Work with attached zip')
      expect(page).to have_content('Generic')
      expect(page).to have_selector('input[type=submit][value=Edit]')
      expect(page).to have_selector('h2', text: 'Parts')
      expect(page).to have_content('work1_preservation.tif')
    end
  end

  context 'when attaching a zip file with file sets to the work' do
    let!(:archival_collection) { create(:archival_collection, title: 'Collection with zipped work') }

    let(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batch1_2018-09-17',
        data: {
          work1: [
            'work1_00001_01_preservation.tif',
            'work1_00001_01_preservation-redacted.tif',
            'work1_00001_01_service.jp2',
            'work1_00001_02_preservation.tif',
            'work1_00001_02_service.jp2',
            'work1_00002_01_preservation.tif',
            'work1_00002_01_service.jp2',
            'work1_00002_02_preservation.tif',
            'work1_00002_02_service.jp2',
            'work1_access.pdf',
            'work1_text.txt',
            'work1_thumb.jpg'
          ]
        }
      )
    end

    let(:zip_file) { ImportFactory::Zip.create(bag) }

    it 'creates a new work object with file sets, files, and a thumbnail from the zip' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource')
      fill_in('work_submission[title]', with: 'Work and file sets with attached zip')
      fill_in('work_submission[home_collection_id]', with: archival_collection.id)
      attach_file('File Selection', zip_file)
      click_button('Create Resource')
      expect(page).to have_content('Work and file sets with attached zip')
      expect(page).to have_content('Generic')
      expect(page).to have_xpath("//img[@src='/files/work1_thumb.jpg']")
      expect(page).to have_xpath("//img[@alt='Work1 thumb']")
      expect(page).to have_selector('input[type=submit][value=Edit]')
      expect(page).to have_selector('h2', text: 'Parts')
      expect(page).to have_content('work1_00001_01_preservation.tif')
      expect(page).to have_content('work1_00001_02_preservation.tif')
      expect(page).to have_content('work1_00002_01_preservation.tif')
      expect(page).to have_content('work1_00002_02_preservation.tif')
    end
  end

  context 'when attaching a zip file with an alternate thumbnail' do
    let!(:archival_collection) { create(:archival_collection, title: 'Collection with alternate thumbnail') }

    let(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batch1_2019-03-12',
        data: {
          work1: [
            'work1_00001_preservation.tif',
            'work1_00001_service.jp2',
            'work1_00001_text.txt',
            'work1_00001_thumb.png',
            'work1_access.pdf'
          ]
        }
      )
    end

    let(:zip_file) { ImportFactory::Zip.create(bag) }

    it 'creates a new work object with file sets, files, and a thumbnail from the zip' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource')
      fill_in('work_submission[title]', with: 'Work and file sets with an alternate thumbnail')
      fill_in('work_submission[home_collection_id]', with: archival_collection.id)
      attach_file('File Selection', zip_file)
      click_button('Create Resource')
      expect(page).to have_content('Work and file sets with an alternate thumbnail')
      expect(page).to have_content('Generic')
      expect(page).to have_xpath("//img[@src='/files/work1_00001_thumb.png']")
      expect(page).to have_xpath("//img[@alt='Work1 00001 thumb']")
      expect(page).to have_selector('input[type=submit][value=Edit]')
      expect(page).to have_selector('h2', text: 'Parts')
      expect(page).to have_link('work1_00001_preservation.tif')

      # Check thumbnail display on the preservation file set
      click_link('work1_00001_preservation.tif')
      expect(page).to have_selector('h1', text: 'work1_00001_preservation.tif')
      expect(page).to have_xpath("//img[@src='/files/work1_00001_thumb.png']")
      expect(page).to have_xpath("//img[@alt='Work1 00001 thumb']")
    end
  end
end
