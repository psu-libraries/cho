# frozen_string_literal: true

Rails.application.routes.draw do
  resources :agent_resources, controller: 'agent/resources', path: 'agents'
  mount DeviseRemote::Engine => '/devise_remote'
  devise_for :users
  mount Blacklight::Engine => '/'
  root to: 'repository/home#index'
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

  resources :work_submissions, as: 'works', path: '/works', except: [:show, :index, :destroy],
                               controller: 'work/submissions'
  resources :work_file_sets, as: 'file_sets', path: '/file_sets', only: [:edit, :update],
                             controller: 'work/file_sets'
  resources :archival_collections, except: [:show, :index, :destroy], controller: 'collection/archival_collections' do
    # Duplicates the same routing syntax for the searching in CatalogController, but in a nested context such that
    # `/archival_collections/:archival_collection_id/resources` serves as a search and browse endpoint for an
    # individual collection.
    resource :resources, only: [:index], as: 'resources', path: 'resources', controller: 'collection/resources' do
      concerns :searchable
    end

    # Duplicates the same routing syntax for displaying solr documents in CatalogController, but in a nested
    # context such that `/archival_collections/:archival_collection_id/resources/:id` displays an individual work
    # within a collection.
    resources :resources, only: [:show], path: 'resources', controller: 'collection/resources' do
      concerns :exportable
    end
  end

  resources :library_collections, except: [:show, :index, :destroy], controller: 'collection/library_collections'
  resources :curated_collections, except: [:show, :index, :destroy], controller: 'collection/curated_collections'
  resources :data_dictionary_fields, controller: 'data_dictionary/fields'

  get '/csv/works/create', to: 'work/import/csv#create'
  get '/csv/works/update', to: 'work/import/csv#update'
  post '/csv/works/validate', to: 'work/import/csv#validate'
  post '/csv/works/import', to: 'work/import/csv#import'

  get '/csv/agents/create', to: 'agent/import/csv#create'
  get '/csv/agents/update', to: 'agent/import/csv#update'
  post '/csv/agents/validate', to: 'agent/import/csv#validate'
  post '/csv/agents/import', to: 'agent/import/csv#import'

  get '/downloads/:id', to: 'repository/downloads#download', as: 'download'

  resource :select, only: [:index], as: 'select', path: 'select', controller: 'batch/select' do
    concerns :searchable
  end

  get '/batch/delete', to: 'batch/delete#index'
  post '/batch/delete', to: 'batch/delete#confirm'
  delete '/batch/delete', to: 'batch/delete#destroy'

  post '/validations/:validation', to: 'validation/validations#validate', as: 'validations'
end
