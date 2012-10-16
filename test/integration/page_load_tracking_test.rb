require 'test_helper'
require 'net/http'

class PageLoadTrackingTest < ActionDispatch::IntegrationTest
  
  test "track a single page load" do
    base = "http://localhost:9393/track?env=test&"
    collector_query = base + FactoryGirl.attributes_for(:load).to_query

    assert_equal 0, Load.all.size
    Net::HTTP.get_response(URI(collector_query))
    assert_equal 1, Load.all.size
  end
  
end