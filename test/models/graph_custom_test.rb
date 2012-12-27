require File.dirname(__FILE__) + "/../minitest_helper"

class GraphTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = Site.create
  end
  
  context "60min duration" do
    before do
      graph_params = hour_params
      graph_params["nr_bars"] = 60

      @graph = GraphCustom.new(graph_params)
      @graph.site = @site
    end
    
    it "should have correct duration" do
      @graph.graph_duration.must_equal 60.minutes
    end

    it "should have correct number of bars" do
      @site.loads.create(time: Time.local(2012, 12, 30,  22, 5))
      @graph.data_uncached.size.must_equal 1
    end
  end
  
  context "day duration" do
    before do
      graph_params = day_params
      graph_params["nr_bars"] = 60
    
      @graph = GraphCustom.new(graph_params)
      @graph.site = @site
    end
    
    it "should work" do
      @graph.graph_duration.must_equal (24.hours - 1.minute)
      @graph.bar_duration.to_i.must_equal 1439
      @graph.nr_bars.must_equal 60
    end
  end
  
  def day_params
    {
      "from(1i)"=>"2012",
      "from(2i)"=>"12",
      "from(3i)"=>"23",
  
      "from(4i)"=>"00",
      "from(5i)"=>"00",
  
  
      "to(1i)"=>"2012",
      "to(2i)"=>"12",
      "to(3i)"=>"23",
  
      "to(4i)"=>"23",
      "to(5i)"=>"59"      
    }
  end
  
  def hour_params
    {
      "from(1i)"=>"2012",
      "from(2i)"=>"12",
      "from(3i)"=>"30",
      
      "from(4i)"=>"22",
      "from(5i)"=>"00",
      
      "to(1i)"=>"2012",
      "to(2i)"=>"12",
      "to(3i)"=>"30",
      
      "to(4i)"=>"23", 
      "to(5i)"=>"00"
    }
  end
  
end
