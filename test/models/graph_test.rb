require File.dirname(__FILE__) + "/../minitest_helper"

class GraphTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = Site.create   
  end
  
  context "60 minutes" do
    before do
      @timeframe = Timeframe.new(duration: 60.minutes)
      @timeframe.from = 60.minutes.ago
      @timeframe.to = Time.now
      @graph = Graph.new({nr_bars: 60}, @timeframe)
      @graph.site = @site
    end
    
    it "should get the correct collection objects" do
      @site.visitors.create
      @site.loads.create
      
      # these should not be counted
      @site2 = Site.create
      @site2.visitors.create
      @site2.visitors.create
      @site2.loads.create
      @site2.loads.create
      
      visitors = @graph.send :visitors
      loads = @graph.send(:loads).collection
      
      visitors.size.must_equal 1
      loads.size.must_equal 1
    end
    
    it "loads_within_range should work" do
      @graph.timeframe.to = Time.now
      @site.loads.create(time: Time.at(30.minutes.ago))
      
      @graph.loads.collection.size.must_equal 1
      @graph.loads.within_range.size.must_equal 1
    end
    
    it "should add one bar" do
      @graph.timeframe.to = Time.now
      @site.loads.create(time: Time.at(30.minutes.ago))
      @graph.loads.within_range.size.must_equal 1
      @graph.data.keys.size.must_equal 1
    end
    
    it "should add correct number of bars" do
      @graph.timeframe.to = Time.now
      
      @site.loads.create(time: Time.at((60 - 0.5).minutes.ago))
      @graph.data_uncached.size.must_equal 1
      
      @site.loads.create(time: Time.at((60 - 1.5).minutes.ago))
      @graph.data_uncached.size.must_equal 2
      
      @site.loads.create(time: Time.at((0.5).minutes.ago))
      @graph.data_uncached.size.must_equal 3
    end
    
    it "should add bars with correct height" do
      @graph.timeframe.to = Time.now
      
      @site.loads.create(time: Time.at((60 - 0.1).minutes.ago))
      @site.loads.create(time: Time.at((60 - 0.5).minutes.ago))
      @site.loads.create(time: Time.at((60 - 0.7).minutes.ago))
      
      @site.loads.create(time: Time.at((60 - 1.5).minutes.ago))
      
      @site.loads.create(time: Time.at((0.5).minutes.ago))
      @site.loads.create(time: Time.at((0.8).minutes.ago))
      
      total_bars_height = @graph.data_uncached.inject(0) { |sum, (k,v)| sum += v }
      @graph.data_uncached.size.must_equal 3 # occasionally errs, todo: make absolute times
      total_bars_height.must_equal 6
    end
    
    it "should not add one bar when out of time range" do
      @graph.timeframe.to = Time.now
      @site.loads.create(time: Time.at(90.minutes.ago))
      @site.loads.create(time: Time.at(61.minutes.ago))
      @site.loads.create(time: Time.at(1.minute.from_now))
      @site.loads.create(time: Time.at(30.minutes.from_now))
      @graph.data.keys.size.must_equal 0
    end
  end
  
end
