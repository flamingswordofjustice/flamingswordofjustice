source 'https://rubygems.org'
ruby '2.0.0'

# Infrastructure

gem 'rails', '3.2.17'
gem 'pg'
gem 'unicorn'
gem 'strong_parameters'
gem 'yajl-ruby'
gem 'multi_json'
gem 'nokogiri'
gem 'rails_12factor'

# Admin

gem 'activeadmin', "~> 0.6.3"
gem 'active_admin_editor'
gem 'meta_search', '>= 1.1.0.pre'
gem 'devise'
gem 'rack-ssl-enforcer'
gem 'newrelic_rpm'
gem 'honeybadger'

# Image Upload

gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

# Assets

gem 'sass-rails'
gem 'haml-rails'
gem 'coffee-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'aws-sdk'
gem 'asset_sync'

# ActiveRecord support

gem 'friendly_id', '~> 4.0.9'
gem 'default_value_for'
gem 'tire'
gem 'acts_as_list'
gem 'kaminari'

# ActionView support

gem 'truncate_html'
gem 'zclip-rails'

# Email

gem 'mailgun'
gem 'active_attr'
# We specifically need HEAD for UTF-8 encoding support. For some reason.
gem 'premailer', git: "https://github.com/alexdunae/premailer"

# Stats

gem "statsd-ruby", require: "statsd"
gem "rest-client"
gem "mixpanel_client"
gem "typhoeus"

group :test do
  gem 'rspec-rails'
  gem 'factory_girl'
end

group :development do
  gem 'foreman'
  gem 'heroku'
end
