require File.dirname(__FILE__) + "/../minitest_helper"
require 'net/http'

class PageLoadTrackingTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers
  
  before do
    @site = FactoryGirl.create :site
  end
  
  test "add a visitor" do
    vid = create_visitor
    @site.visitors.size.must_equal 1
  end
  
  test "track a page load using a direct API call" do
    attr = FactoryGirl.attributes_for(:load)
    attr[:visitor_id] = create_visitor
    track_load(attr)
    
    @site.loads.size.must_equal 1
    @site.visitors.first.loads.first.must_equal @site.loads.first
  end

end