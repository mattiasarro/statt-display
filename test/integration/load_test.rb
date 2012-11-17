require File.dirname(__FILE__) + "/../minitest_helper"

class LoadTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelpers
  
  before do
    @site = FactoryGirl.create(:site)
    @visitor = @site.visitors.create FactoryGirl.attributes_for(:visitor)
    # @loads = @site.loads # @loads like this doesn't work :S
  end
  
  context "when setting previous/next load" do
    it "should have no :previous if referer outside the site" do
      load_attr = FactoryGirl.attributes_for(:load, 
                                              http_referer: "http://google.com/search?id=asdf", 
                                              visitor_id: @visitor.id)
      track_load(load_attr)
      assert @site.loads.first.previous.nil?
    end
    
    it "should have a :previous if referer from this site; :previous should have :next" do
          uri = "http://mysite.com/"
          from = FactoryGirl.attributes_for(:load, 
                   http_referer: "http://google.com/search?id=asdf", 
                   uri_string: uri,
                   visitor_id: @visitor.id,
                   query_parameters: "from")
          to   = FactoryGirl.attributes_for(:load, 
                   http_referer: uri, 
                   uri_string: "http://mysite.com/blog/", 
                   visitor_id: @visitor.id,
                   query_parameters: "to")
          
          track_load from
          track_load to
          @site.reload.loads.size.must_equal 2
          
          from = @site.loads.find_by(query_parameters: "from")
          to   = @site.loads.find_by(query_parameters: "to")
          
          from.next.must_equal to
          to.previous.must_equal from
        end

    it "should set the correct :previous in case of multiple loads with same referer" do
      uri = "http://mysite.com/"
      earlier = FactoryGirl.attributes_for(:load, 
                  http_referer: "http://google.com/search?id=asdf", 
                  uri_string: uri, 
                  visitor_id: @visitor.id,
                  time: Time.at(1.hour.ago))
      from    = FactoryGirl.attributes_for(:load, 
                  http_referer: "http://google.com/search?id=asdf", 
                  uri_string: uri, 
                  visitor_id: @visitor.id,
                  query_parameters: "from")
      to      = FactoryGirl.attributes_for(:load, 
                  http_referer: uri, 
                  uri_string: "http://mysite.com/blog/", 
                  visitor_id: @visitor.id,
                  query_parameters: "to")
      track_load earlier
      track_load from
      track_load to
      
      @site.loads.size.must_equal 3
      from = @site.loads.find_by(query_parameters: "from")
      to = @site.loads.find_by(query_parameters: "to")
      
      to.previous.must_equal from
      from.next.must_equal to
    end
  end
  
  context "when calculating time_on_page" do
      it "shouldn't get time_on_page when user hasn't loaded a new page" do
        load = FactoryGirl.attributes_for(:load, 
                 time: Time.at(30.seconds.ago), 
                 visitor_id: @visitor.id)
        track_load load
        
        @site.loads.size.must_equal 1
        @site.loads.first.time_on_page.must_equal nil
      end
      
      it "should calculate time_on_page when user has loaded a new page" do
        uri = "http://mysite.com/"
        from = FactoryGirl.attributes_for(:load, 
                 time: Time.at(100.seconds.ago), 
                 uri_string: uri, 
                 http_referer: "http://google.com/search?id=asdf", 
                 visitor_id: @visitor.id,
                 query_parameters: "from")
        to   = FactoryGirl.attributes_for(:load, 
                 time: Time.at(70.seconds.ago), 
                 http_referer: uri, 
                 uri_string: "http://mysite.com/blog/", 
                 visitor_id: @visitor.id,
                 query_parameters: "to")
        
        track_load from
        track_load to
        
        from = @site.loads.find_by(query_parameters: "from")
        to   = @site.loads.find_by(query_parameters: "to")
                
        @site.loads.size.must_equal 2
        visitor_loads.must_equal [from,to]
        from.time_on_page.must_equal 30
      end
    end
  
  def visitor_loads
    @site.visitors.first.loads.asc(:time).to_a
  end
end