source 'http://rubygems.org'
ruby "2.3.1"

gem 'rails', '3.2.22'
gem 'jquery-rails', '1.0.19'
gem 'devise', '1.4.9'
gem 'cancan', '1.6.7'
gem 'pg'
gem 'aws-s3'
gem 'kaminari'
gem 'opinio', '0.5'
gem 'formtastic'
gem 'redcarpet'
gem 'nokogiri'

group :production do
  gem 'thin'
end

group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.1.0'
end

group :development do
  gem 'mongrel', '>= 1.2.0.pre2'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy' # save_and_open_page
end
