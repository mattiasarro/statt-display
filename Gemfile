source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.11'

gem 'thin' # use this for dev & production
gem 'mongoid', "~> 3.0.0"
gem 'database_cleaner'

gem 'omniauth'
gem 'omniauth-twitter'

gem 'inherited_resources'
gem 'haml-rails'
gem 'quiet_assets'
gem 'dotiw' # distance of time in words

gem 'faker'
group :development do
  gem 'pry'
  gem 'pry-doc'
  gem 'better_errors'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara-webkit'
  gem 'minitest-rails'
  gem 'minitest-rails-capybara'
  gem 'minitest-spec-context'
  # gem 'turn' # highlighting test output; alternative to 'pride'

  gem 'guard-minitest'
  gem 'rb-fsevent', :require => false
end

group :assets do
  # Assets - can't explicitly exclude assets group in Heroku
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-ui-rails'
  
  gem "less-rails" # adds .less support for asset pipeline
  gem 'therubyracer' # allow Ruby programs to call the V8 JS engine
  gem 'twitter-bootstrap-rails' # vendor/assets/bootstrap.less etc.
  
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'
