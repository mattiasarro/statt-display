require File.dirname(__FILE__) + "/../test_helper"

describe Visitor do
  
  it "should generate Visitors array of the correct length based on timeframe" do
    Visitor.where(:time.gt => 30.minutes.ago).must_be_empty
    
    FactoryGirl.create(:load, time:  5.minutes.ago, cl_user_id: 1)
    FactoryGirl.create(:load, time:  7.minutes.ago, cl_user_id: 1)
    FactoryGirl.create(:load, time:  8.minutes.ago, cl_user_id: 1)
    
    FactoryGirl.create(:load, time: 15.minutes.ago, cl_user_id: 2)
    FactoryGirl.create(:load, time: 20.minutes.ago, cl_user_id: 2)
    
    FactoryGirl.create(:load, time: 29.minutes.ago, cl_user_id: 3)
    
    FactoryGirl.create(:load, time: 31.minutes.ago, cl_user_id: 4)
    
    Visitor.refresh_from_loads(:from => 10.minutes.ago)
    Visitor.all.size.must_equal 1
    visitors_total_loads.must_equal 3
        
    Visitor.refresh_from_loads(:from => 16.minutes.ago)
    Visitor.all.size.must_equal 2
    visitors_total_loads.must_equal 4
    Visitor.refresh_from_loads(:from => 21.minutes.ago)
    Visitor.all.size.must_equal 2
    visitors_total_loads.must_equal 5
    
    Visitor.refresh_from_loads(:from => 30.minutes.ago)
    Visitor.all.size.must_equal 3
    visitors_total_loads.must_equal 6
    
    Visitor.refresh_from_loads(:from => 40.minutes.ago)
    Visitor.all.size.must_equal 4
    visitors_total_loads.must_equal 7
  end
  
  it "should create Visitor db entry with track_page_load" do
    visitor = FactoryGirl.build(:visitor)
    load = FactoryGirl.create(:load)
    
    visitor.track_page_load(load)
    Visitor.all.size.must_equal 1
  end
  
  it "should find visitor based on cookie ID" do
    v = FactoryGirl.create(:visitor, cookie_ids: [1])
    visitor = Visitor.find_by_user_or_cookie_id(nil, 1)
    refute visitor.new_record?
    visitor.must_equal v
  end
  
  it "should find visitor based on ClientUserId" do
    v = FactoryGirl.create(:visitor, cookie_ids: [1], cl_user_id: "ClientUserId")
    
    visitor = Visitor.find_by_user_or_cookie_id("ClientUserId", nil)
    refute visitor.new_record?
    visitor.must_equal v
    
    # Use a different cookie_id, still should find by cl_user_id
    visitor = Visitor.find_by_user_or_cookie_id("ClientUserId", 2000)
    refute visitor.new_record?
    visitor.must_equal v
  end
  
  it "should update ClientUserId with track_page_load" do
    visitor = FactoryGirl.create(:visitor, cl_user_id: nil, cookie_ids: [3])
    load = FactoryGirl.create(:load, cl_user_id: "new cl_user_id", cookie_id: 3)
    
    visitor.track_page_load(load)
    visitor.reload.cl_user_id.must_equal "new cl_user_id"
  end
  
  it "should update cookie_ids with track_page_load" do
    visitor = FactoryGirl.create(:visitor, cl_user_id: "CUI", cookie_ids: [3])
    load = FactoryGirl.create(:load, cl_user_id: "CUI", cookie_id: 4)
    
    visitor.track_page_load(load)
    assert visitor.reload.cookie_ids.include?(4)
    visitor.reload.cookie_ids.size.must_equal 2
  end
  
  it "should update Load#visitor_id with track_page_load" do
    visitor = FactoryGirl.create(:visitor, cl_user_id: "CUI", cookie_ids: [3])
    load = FactoryGirl.create(:load, cl_user_id: "CUI", cookie_id: 4)
    
    visitor.track_page_load(load)
    load.reload.visitor_id.must_equal visitor.id
  end
  
  def visitors_total_loads
    Visitor.all.inject(0) {|sum,v| sum + v.loads.size }
  end
end