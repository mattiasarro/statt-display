require File.dirname(__FILE__) + "/../minitest_helper"

class LoadTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = FactoryGirl.create(:site)
    @visitor = @site.visitors.create FactoryGirl.attributes_for(:visitor)
    @loads = @site.loads
  end
  
  context "when setting previous/next load" do
    it "should have no :previous if referer outside the site" do
      load = @loads.create FactoryGirl.attributes_for(:load, http_referer: "http://google.com/search?id=asdf", visitor_id: @visitor.id)
      assert load.previous.nil?
    end

    it "should have a :previous if referer from this site; :previous should have :next" do
      uri = "http://mysite.com/"
      from = @loads.create FactoryGirl.attributes_for(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf", visitor_id: @visitor.id)
      to   = @loads.create FactoryGirl.attributes_for(:load, http_referer: uri, uri_string: "http://mysite.com/blog/", visitor_id: @visitor.id)

      @site.reload.loads.size.must_equal 2
      from.next.must_equal to
      to.previous.must_equal from
    end

    it "should set the correct :previous in case of multiple loads with same referer" do
      uri = "http://mysite.com/"
      earlier = @loads.create FactoryGirl.attributes_for(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf", visitor_id: @visitor.id)
      from = @loads.create FactoryGirl.attributes_for(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf", visitor_id: @visitor.id)
      to   = @loads.create FactoryGirl.attributes_for(:load, http_referer: uri, uri_string: "http://mysite.com/blog/", visitor_id: @visitor.id)

      @loads.size.must_equal 3
      visitor_loads.must_equal [earlier,from,to]
      @loads.find(to.id).previous.must_equal from
      @loads.find(from.id).next.must_equal to
    end
  end
  
  context "when calculating time_on_page" do
    it "shouldn't get time_on_page when user hasn't loaded a new page" do
      load = @loads.create FactoryGirl.attributes_for(:load, time: 30.seconds.ago, visitor_id: @visitor.id)
      @loads.size.must_equal 1
      load.time_on_page.must_equal nil
    end
    
    it "should calculate time_on_page when user has loaded a new page" do
      uri = "http://mysite.com/"
      from = @loads.create FactoryGirl.attributes_for(:load, time: 100.seconds.ago, uri_string: uri, http_referer: "http://google.com/search?id=asdf", visitor_id: @visitor.id)
      to   = @loads.create FactoryGirl.attributes_for(:load, time: 70.seconds.ago, http_referer: uri, uri_string: "http://mysite.com/blog/", visitor_id: @visitor.id)

      @loads.size.must_equal 2
      visitor_loads.must_equal [from,to]
      @loads.find(from.id).time_on_page.must_equal 30
    end
  end
  
  def visitor_loads
    @site.visitors.first.loads.asc(:time).to_a
  end
end