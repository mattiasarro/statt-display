ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"

# Uncomment if you want Capybara in accceptance/integration tests
# require "minitest/rails/capybara"

require "minitest/pride"

class MiniTest::Rails::ActiveSupport::TestCase
  setup :clean_mongodb
  teardown :clean_mongodb
  
  def clean_mongodb
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
    DatabaseCleaner.clean
  end
end

MiniTest::Rails.override_testunit!

# HELPERS

module ControllerTestHelpers
  def login(factory_symbol)
    @current_user = FactoryGirl.create(factory_symbol)
    session[:user_id] = @current_user.id
    return @current_user
  end
end