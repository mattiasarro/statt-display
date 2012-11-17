require File.dirname(__FILE__) + "/../minitest_helper"

class VisitorTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers

  before do
    @site = FactoryGirl.create(:site)
    @visitor = @site.visitors.create FactoryGirl.attributes_for(:visitor)
  end    
  
  it "should update cl_user_id when load created" do
    uid = "john-doe-unique"
    
    l = FactoryGirl.attributes_for(:load, 
          visitor_id: @visitor.id, 
          cl_user_id: uid)
    track_load l
    
    visitor.cl_user_ids.must_include uid
    visitor.current_cl_user_id.must_equal uid
  end
  
  context "visitor.to_s" do
    it "should display latest cl_user_id if present" do
      l1 = FactoryGirl.attributes_for(:load, 
             visitor_id: @visitor.id, 
             cl_user_id: "johnny", 
             ip: "192.168.1.1",
             time: Time.at(1.hour.ago))
      l2 = FactoryGirl.attributes_for(:load, 
             visitor_id: @visitor.id, 
             cl_user_id: "john-doe", 
             ip: "192.168.1.2")
      
      track_load l1 
      track_load l2
      
      visitor.to_s.must_equal "john-doe"
    end
    
    it "should fall back to the IP address" do
      @visitor = @site.visitors.create # no cl_user_ids
      l1 = FactoryGirl.attributes_for(:load, 
             visitor_id: @visitor.id, 
             cl_user_id: nil, 
             ip: "192.168.1.1",
             time: Time.at(1.hour.ago))
      l2 = FactoryGirl.attributes_for(:load, 
             visitor_id: @visitor.id, 
             cl_user_id: nil, 
             ip: "192.168.1.2")
      
      track_load l1
      track_load l2
      visitor.to_s.must_equal "192.168.1.2"
    end
  end
  
  def visitor
    @site.visitors.find(@visitor.id)
  end
end