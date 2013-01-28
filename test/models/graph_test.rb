require File.dirname(__FILE__) + "/../minitest_helper"

class GraphTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = Site.create   
  end
  
  context "60 minutes" do
    before do
      @timeframe = Timeframe.new(duration: 60.minutes)
      @timeframe.from = Time.utc(2013,1,1, 0,0)
      @timeframe.to = Time.utc(2013,1,1, 1,0)
      @loads = Loads.new(@site, @timeframe)
      @graph = Graph.new(@loads, 60)
      @graph.site = @site
    end
    
    it "should get the correct collection objects" do
      @site.visitors.create
      @site.loads.create(time: Time.utc(2013,1,1, 0,30))
      
      # these should not be counted
      @site2 = Site.create
      @site2.visitors.create
      @site2.visitors.create
      @site2.loads.create(time: Time.utc(2013,1,1, 0,30))
      @site2.loads.create(time: Time.utc(2013,1,1, 0,30))
      
      visitors = @graph.send :visitors
      
      visitors.size.must_equal 1
      @loads.within_range.size.must_equal 1
    end
    
    it "should add one bar" do
      @site.loads.create(time: Time.utc(2013,1,1, 0,30))
      @loads.within_range.size.must_equal 1
      @graph.data.keys.size.must_equal 1
    end
    
    it "should add correct number of bars" do
      @site.loads.create(time: Time.utc(2013,1,1, 0,5))
      @graph.data_uncached.size.must_equal 1
      
      @site.loads.create(time: Time.utc(2013,1,1, 0,15))
      @graph.data_uncached.size.must_equal 2
      
      @site.loads.create(time: Time.utc(2013,1,1, 0,30))
      @graph.data_uncached.size.must_equal 3
    end
    
    it "should add bars with correct height" do
      @site.loads.create(time: Time.utc(2013,1,1, 0, 1,10))
      @site.loads.create(time: Time.utc(2013,1,1, 0, 1,15))
      @site.loads.create(time: Time.utc(2013,1,1, 0, 1,20))
      
      @site.loads.create(time: Time.utc(2013,1,1, 0, 2, 1))
      
      @site.loads.create(time: Time.utc(2013,1,1, 0,59,30))
      @site.loads.create(time: Time.utc(2013,1,1, 0,59,59))
      
      total_bars_height = @graph.data_uncached.inject(0) { |sum, (k,v)| sum += v }
      @graph.data_uncached.size.must_equal 3 # occasionally errs, todo: make absolute times
      total_bars_height.must_equal 6
    end
    
    it "should not add one bar when out of time range" do
      @site.loads.create(time: Time.utc(2012,12,31, 23,0))
      @site.loads.create(time: Time.utc(2012,12,31, 23,59))
      @site.loads.create(time: Time.utc(2013,1,1, 1,1))
      @site.loads.create(time: Time.utc(2013,1,1, 2,0))
      @graph.data.keys.size.must_equal 0
    end
  end
  
end
