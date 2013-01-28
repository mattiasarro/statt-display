require File.dirname(__FILE__) + "/../minitest_helper"

class LoadsPageTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = Site.create   
  end
  
  context "graph.loads pagination" do
    before do
      @timeframe = Timeframe.new(duration: 60.minutes)
      @timeframe.from = Time.utc(2013,1,1, 22,0)
      @timeframe.to   = Time.utc(2013,1,1, 23,0)
      
      @loads = Loads.new(@site, @timeframe)
    end
    
    it "should get only loads from the correct site" do
      @site.visitors.create
      @site.loads.create(time: Time.utc(2013,1,1, 22,1))
      
      # these should not be counted
      @site2 = Site.create
      @site2.loads.create
      @site2.loads.create
      
      loads_columns = @loads.page(1).to_array
      loads_columns.flatten.size.must_equal 1 # one load
      loads_columns[0].size.must_equal 1 # one load in the first subarray
      loads_columns.size.must_equal 1 # only one subarray
    end
    
    it "should get a proper last page" do
      silence_warnings do
        Loads::PER_PAGE = 10
      end
      
      setup_two_pages
      
      @site.loads.size.must_equal 19
      @loads.page(1).send(:loads_size).must_equal 9
      @loads.page(2).send(:loads_size).must_equal 10
      
      loads_columns = @loads.page(1).to_array
      loads_columns.flatten.size.must_equal 9
      loads_columns.size.must_equal 3
      loads_columns[0].size.must_equal 3
      loads_columns[1].size.must_equal 3
      loads_columns[2].size.must_equal 3
      
      loads_columns = @loads.page(2).to_array
      loads_columns.flatten.size.must_equal 10
      loads_columns.size.must_equal 3
      loads_columns[0].size.must_equal 4
      loads_columns[1].size.must_equal 4
      loads_columns[2].size.must_equal 2
    end
    
    it "should count the loads on page correctly" do
      silence_warnings do
        Loads::PER_PAGE = 10
      end
      setup_two_pages
      
      @loads.page(1).send(:loads_size).must_equal 9
    end
  end
  
  def setup_two_pages
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
  end
    
end
