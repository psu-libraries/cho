# frozen_string_literal: true

Rails.application.routes.draw do
  resources :data_dictionary_fields, controller: 'data_dictionary/fields'

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

  resources :work_object_deposits, as: 'work_objects', path: '/work_objects', except: [:show, :index], controller: 'work_object/deposits'
end
