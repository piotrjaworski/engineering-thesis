source 'https://rubygems.org'

# rails core
gem 'rails', '4.2.0'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# database
gem 'pg'
gem 'pg_search'

# user authentication
gem 'devise'
gem 'cancancan', '~> 1.10'
gem 'omniauth-google-oauth2'

# styles & javascript
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'jquery-rails'
gem 'font-awesome-rails'

# queue system
gem 'sidekiq'
gem 'sinatra', require: false

# other
gem 'simple_form'
gem 'will_paginate-bootstrap'
gem 'impressionist'
gem 'paperclip', '~> 4.3'
gem 'figaro'
gem 'newrelic_rpm'
gem 'friendly_id', '~> 5.1.0'
gem 'bootstrap3_autocomplete_input'
gem 'therubyracer', platforms: :ruby
gem 'faker'
gem 'exception_notification'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rubocop', require: false
  gem 'quiet_assets'
  # gem 'capistrano-rails'
end

group :test do
  gem 'shoulda-matchers', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
end

group :development, :test do
  gem 'pry'
end
