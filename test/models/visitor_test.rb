require File.dirname(__FILE__) + "/../minitest_helper"

class VisitorTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = FactoryGirl.create(:site)
    @loads = @site.loads
    @visitors = @site.visitors
  end
  
  it "should create Visitor db entry with track_page_load" do
    visitor = @visitors.build FactoryGirl.attributes_for(:visitor)
    load = @loads.create FactoryGirl.attributes_for(:load)
    
    visitor.track_page_load(load)
    @visitors.size.must_equal 1
  end
    
  it "should find visitor based on cookie ID" do
    v = @visitors.create FactoryGirl.attributes_for(:visitor, cookie_ids: [1])
    visitor = @visitors.find_by_user_or_cookie_id(nil, 1)
    refute visitor.new_record?
    visitor.must_equal v
  end
  
  it "should find visitor based on ClientUserId" do
    v = @visitors.create(cookie_ids: [1], cl_user_id: "ClientUserId")
    
    visitor = @visitors.find_by_user_or_cookie_id("ClientUserId", nil)
    refute visitor.new_record?
    visitor.must_equal v
    
    # Use a different cookie_id, still should find by cl_user_id
    visitor = @visitors.find_by_user_or_cookie_id("ClientUserId", 2000)
    refute visitor.new_record?
    visitor.must_equal v
  end
  
  it "should update ClientUserId with track_page_load" do
    visitor = @visitors.create(cl_user_id: nil, cookie_ids: [3])
    load = @loads.create(cl_user_id: "new cl_user_id", cookie_id: 3, time: Time.now)
    
    visitor.track_page_load(load)
    visitor.reload.cl_user_id.must_equal "new cl_user_id"
  end
  
  it "should update cookie_ids with track_page_load" do
    visitor = @visitors.create(cl_user_id: "CUI", cookie_ids: [3])
    load = @loads.create(cl_user_id: "CUI", cookie_id: 4, time: Time.now)
    
    visitor.track_page_load(load)
    assert visitor.reload.cookie_ids.include?(4)
    visitor.reload.cookie_ids.size.must_equal 2
  end

  it "should update Load#visitor_id with track_page_load" do
      visitor = @visitors.create(cl_user_id: "CUI", cookie_ids: [3])
      load = @loads.create(cl_user_id: "CUI", cookie_id: 4, time: Time.now)
      
      visitor.track_page_load(load)
      load_refreshed = @loads.find(load.id)
      load_refreshed.visitor_id.must_equal visitor.id
  end
    
  it "should generate Visitors array of the correct length based on timeframe" do
    @loads.create(time:  5.minutes.ago, cl_user_id: 1)
    @loads.create(time:  7.minutes.ago, cl_user_id: 1)
    @loads.create(time:  8.minutes.ago, cl_user_id: 1)
    
    @loads.create(time: 15.minutes.ago, cl_user_id: 2)
    @loads.create(time: 20.minutes.ago, cl_user_id: 2)
    
    @loads.create(time: 29.minutes.ago, cl_user_id: 3)
    
    @loads.create(time: 31.minutes.ago, cl_user_id: 4)
    
    @site.refresh_visitors(:from => 10.minutes.ago)
    @visitors.size.must_equal 1
    visitors_total_loads.must_equal 3
        
    @site.refresh_visitors(:from => 16.minutes.ago)
    @visitors.size.must_equal 2
    visitors_total_loads.must_equal 4
    @site.refresh_visitors(:from => 21.minutes.ago)
    @visitors.size.must_equal 2
    visitors_total_loads.must_equal 5
    
    @site.refresh_visitors(:from => 30.minutes.ago)
    @visitors.size.must_equal 3
    visitors_total_loads.must_equal 6
    
    @site.refresh_visitors(:from => 40.minutes.ago)
    @visitors.size.must_equal 4
    visitors_total_loads.must_equal 7
  end
   
  def visitors_total_loads
    @visitors.inject(0) {|sum,v| sum + v.loads.size }
  end
end