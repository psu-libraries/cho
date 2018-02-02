# frozen_string_literal: true

Rails.application.routes.draw do
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

  get '/elm', to: 'application#index'

  resources :work_object_deposits, as: 'work_objects', path: '/work_objects', except: [:show, :index], controller: 'work_object/deposits'
  resources :archival_collections, except: [:show, :index], controller: 'collection/archival_collections'
  resources :library_collections, except: [:show, :index], controller: 'collection/library_collections'
  resources :curated_collections, except: [:show, :index], controller: 'collection/curated_collections'
  resources :data_dictionary_fields, controller: 'data_dictionary/fields'
end
