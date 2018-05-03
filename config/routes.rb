# frozen_string_literal: true

Rails.application.routes.draw do
  mount DeviseRemote::Engine => '/devise_remote'
  devise_for :users
  mount Blacklight::Engine => '/'
  root to: 'catalog#index'
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :work_submissions, as: 'works', path: '/works', except: [:show, :index, :destroy], controller: 'work/submissions'
  resources :archival_collections, except: [:show, :index, :destroy], controller: 'collection/archival_collections'
  resources :library_collections, except: [:show, :index, :destroy], controller: 'collection/library_collections'
  resources :curated_collections, except: [:show, :index, :destroy], controller: 'collection/curated_collections'
  resources :data_dictionary_fields, controller: 'data_dictionary/fields'

  resources :work_import_csvfile, as: 'csv_file', path: '/csv_file', only: [:new, :create], controller: 'work/import/csv'
  post '/csv_file/run_import', to: 'work/import/csv#run_import'

  get '/select', to: 'batch/select#index'

  get '/batch/delete', to: 'batch/delete#index'
  post '/batch/delete', to: 'batch/delete#confirm'
  delete '/batch/delete', to: 'batch/delete#destroy'
end
