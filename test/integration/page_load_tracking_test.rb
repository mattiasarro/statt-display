require File.dirname(__FILE__) + "/../minitest_helper"
require 'net/http'

class PageLoadTrackingTest < ActionDispatch::IntegrationTest
  
  
  test "add a visitor" do
    
  end
  
  test "track a single page load" do
    skip
    base  = Rails.configuration.collect_host
    base += "/sites/#{@site.id}/" '/track.png?'
    
    @site = FactoryGirl.create :site
    attr = FactoryGirl.attributes_for(:load)
    attr[:site_id] = @site.id
    
    collector_query = base + attr.to_query
    
    assert_equal 0, Site.first.loads.all.size
    Net::HTTP.get_response(URI(collector_query))
    assert_equal 1, Site.first.loads.all.size
  end
  
end