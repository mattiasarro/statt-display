require File.dirname(__FILE__) + "/../minitest_helper"

class VisitorTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = FactoryGirl.create(:site)
    @visitor = @site.visitors.create
    @loads = @site.loads
  end    
  
  it "should update cl_user_id when load created" do
    uid = "john-doe-unique"
    @loads.create FactoryGirl.attributes_for(:load, visitor_id: @visitor.id, cl_user_id: uid)
    @visitor.reload
    @visitor.cl_user_ids.must_include uid
    @visitor.current_cl_user_id.must_equal uid
  end
  
  context "visitor.to_s" do
    it "should display latest cl_user_id if present" do
      @loads.create FactoryGirl.attributes_for(:load, visitor_id: @visitor.id, cl_user_id: "johnny", ip: "192.168.1.1")
      @loads.create FactoryGirl.attributes_for(:load, visitor_id: @visitor.id, cl_user_id: "john-doe", ip: "192.168.1.2")
      @visitor.to_s.must_equal "john-doe"
    end
    
    it "should fall back to the IP address" do
      @loads.create FactoryGirl.attributes_for(:load, visitor_id: @visitor.id, cl_user_id: "", ip: "192.168.1.1")
      @loads.create FactoryGirl.attributes_for(:load, visitor_id: @visitor.id, cl_user_id: "", ip: "192.168.1.2")
      @visitor.to_s.must_equal "192.168.1.2"
    end
  end
  
end