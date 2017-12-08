# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Main gems
gem 'rails', '~> 5.1.3'
gem 'valkyrie', github: 'samvera-labs/valkyrie'

# Supporting gems
gem 'coffee-rails', '~> 4.2'
gem 'execjs'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'json'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rsolr', '>= 1.0'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'solr_wrapper', '>= 0.3'
  gem 'sqlite3'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'xray-rails'

  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.7', require: false
  gem 'capistrano-bundler', '~> 1.2', require: false
  gem 'capistrano-rails', '~> 1.2', require: false
  gem 'capistrano-rbenv', '~> 2.1', require: false
  gem 'capistrano-rbenv-install'
  gem 'capistrano-resque', '~> 0.2.1', require: false
end

group :test do
  gem 'capybara'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

# @todo https://github.com/psu-libraries/cho-req/issues/225
group :production do
  # gem 'newrelic_rpm'
end
