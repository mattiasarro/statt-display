require File.dirname(__FILE__) + "/../minitest_helper"
require 'net/http'

class PageLoadTrackingTest < ActionDispatch::IntegrationTest
  
  setup do
    Capybara.current_driver = :webkit
  end
  
  before do
    @site = FactoryGirl.create :site
    @base = "http://local.collect_test/sites/#{@site.id}"
  end
  
  test "add a visitor" do
    create_visitor
    @site.visitors.size.must_equal 1
  end
  
  test "track a page load using a direct API call" do
    visitor_id = create_visitor
    attr = FactoryGirl.attributes_for(:load).merge({visitor_id: visitor_id})
    visit @base + "/track.png?" + attr.to_query
    @site.loads.size.must_equal 1
    @site.visitors.first.loads.must_equal @site.loads
  end
  
  def create_visitor
    Moped::BSON::ObjectId.new.tap do |visitor_id|
      visit @base + "/new_visitor.png?visitor_id=#{visitor_id}"
    end
  end
  
end