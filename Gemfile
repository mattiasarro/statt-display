source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.8'

gem 'thin' # use this for dev & production
gem 'mongoid', "~> 3.0.0"
gem 'database_cleaner'

gem 'omniauth'
gem 'omniauth-twitter'

gem 'inherited_resources'
gem 'haml-rails'
gem 'quiet_assets'

group :development do
  gem 'pry'
  gem 'pry-doc'
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
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'
