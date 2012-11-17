ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"

# Uncomment if you want Capybara in accceptance/integration tests
# require "minitest/rails/capybara"

require "minitest/pride"

class MiniTest::Rails::ActiveSupport::TestCase
  setup :clean_mongodb
  # teardown :clean_mongodb
  
  def clean_mongodb
    cmd = "db.dropDatabase();"
    Site.collection.database.command("$eval" => cmd, "nolock" => false)
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

module IntegrationTestHelpers
  
  def self.included(to)
    to.setup do
      Capybara.current_driver = :webkit
    end
  end
  
  def base_uri
    "http://local.collect_test/"
  end
  
  def create_visitor
    Moped::BSON::ObjectId.new.tap do |visitor_id|
      attr = {
        visitor_id: visitor_id,
        site_id: @site.id
      }
      uri  = base_uri + "new_visitor.png?" + attr.to_query
      # puts "visiting #{uri}"
      visit uri
      sleep(1)
    end
  end
  
  def track_load(attr)
    attr = attr.merge({site_id: @site.id})
    uri = base_uri + "track.png?" + attr.to_query
    # puts "visiting #{uri}"
    visit uri
    sleep(1)
  end
end