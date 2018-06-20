source 'https://rubygems.org'

ruby "2.2.4"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

gem 'lazy_high_charts'
gem 'kaminari'
gem 'google-analytics-rails'
gem 'omniauth'
gem 'omniauth-twitter'
#gem 'omniauth-facebook'
#gem 'omniauth-google-oauth2'
#gem 'omniauth-yahoojp'
#gem 'omniauth-mixi'
# gem 'rails_config'
gem 'config'
gem 'bootstrap-sass'
gem 'faker'
#gem 'taps'

gem 'pry-rails'
gem 'pry-doc'
gem 'pry-stack_explorer'
gem 'pry-byebug'

# Use debugger
# gem 'debugger', group: [:development, :test]
group :development, :test do
# To use debugger
#  gem 'debugger'
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'rails-erd'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
  gem 'capybara'
  # gem 'factory_girl_rails'
  gem 'factory_bot'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'database_cleaner'
end

group :production do
  gem 'pg', '~> 0.21.0'
  gem 'rails_12factor'
end
