# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Main gems
gem 'blacklight', '~> 7.0'
gem 'rails', '~> 5.1.6'
gem 'valkyrie', '~> 1.0'

# For Blacklight with Sprockets
gem 'bootstrap', '~> 4.3'
gem 'popper_js'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'

# Supporting gems
gem 'bagit'
gem 'blacklight-gallery', git: 'https://github.com/projectblacklight/blacklight-gallery'
gem 'bootsnap', require: false
gem 'cancancan'
gem 'coffee-rails', '~> 4.2'
gem 'devise_remote'
gem 'dry-transaction'
gem 'edtf'
gem 'execjs'
gem 'faker'
gem 'figaro'
gem 'hydra-derivatives'
gem 'hydra-file_characterization', '~> 0.3.3'
gem 'hydra-ldap'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'json'
gem 'mini_racer'
gem 'pg'
gem 'psu_dir'
gem 'puma', '~> 3.7'
gem 'rsolr', '>= 1.0'
gem 'rubyzip'
gem 'sass-rails', '~> 5.0'
gem 'shrine'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 4.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_bot_rails'
  gem 'niftany'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'solr_wrapper'
  gem 'sqlite3'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'flog'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'travis', require: false
  gem 'web-console', '>= 3.3.0'
  gem 'xray-rails'

  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-bundler', '~> 1.5', require: false
  gem 'capistrano-passenger' , '~> 0.2', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rbenv', '~> 2.1', require: false
  gem 'capistrano-rbenv-install' ', '~> 1.2', require: false
  gem 'capistrano-resque', '~> 0.2.1', require: false
end

group :test do
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'webdrivers'
end

group :production do
  gem 'newrelic_rpm'
end
