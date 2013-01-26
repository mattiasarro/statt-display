require File.dirname(__FILE__) + "/../minitest_helper"

class LoadTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = Site.create   
  end
  
  context "graph.loads pagination" do
    before do
      @graph = Graph.factory({type: :hour})
      @graph.from = Time.utc(2013,1,1, 22,0)
      @graph.to   = Time.utc(2013,1,1, 23,0)
      @graph.site = @site
    end
    
    it "should get only loads from the correct site" do
      @site.visitors.create
      @site.loads.create(time: Time.utc(2013,1,1, 22,1))
      
      # these should not be counted
      @site2 = Site.create
      @site2.loads.create
      @site2.loads.create
      
      @graph.loads_page(1).size.must_equal 1
    end
    
    # todo don't assume PER_PAGE = 10
    it "should get a proper last page" do      
      @site.loads.create(time: Time.utc(2013,1,1, 22,1))
      @site.loads.create(time: Time.utc(2013,1,1, 22,2))
      @site.loads.create(time: Time.utc(2013,1,1, 22,3))
      @site.loads.create(time: Time.utc(2013,1,1, 22,4))
      @site.loads.create(time: Time.utc(2013,1,1, 22,5))
      @site.loads.create(time: Time.utc(2013,1,1, 22,6))
      @site.loads.create(time: Time.utc(2013,1,1, 22,7))
      @site.loads.create(time: Time.utc(2013,1,1, 22,8))
      @site.loads.create(time: Time.utc(2013,1,1, 22,9))
      @site.loads.create(time: Time.utc(2013,1,1, 22,10))
      
      @site.loads.create(time: Time.utc(2013,1,1, 22,11))
      @site.loads.create(time: Time.utc(2013,1,1, 22,12))
      @site.loads.create(time: Time.utc(2013,1,1, 22,13))
      @site.loads.create(time: Time.utc(2013,1,1, 22,14))
      @site.loads.create(time: Time.utc(2013,1,1, 22,15))
      @site.loads.create(time: Time.utc(2013,1,1, 22,16))
      @site.loads.create(time: Time.utc(2013,1,1, 22,17))
      @site.loads.create(time: Time.utc(2013,1,1, 22,18))
      @site.loads.create(time: Time.utc(2013,1,1, 22,19))
      
      # have to use map(&:time) because just .size() won't take the limit into account
      @graph.loads_page(2).map(&:time).size.must_equal 9
    end
  end
  
end
