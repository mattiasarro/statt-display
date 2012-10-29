require File.dirname(__FILE__) + "/../minitest_helper"

class LoadTest < MiniTest::Rails::ActiveSupport::TestCase
  
  before do
    @site = FactoryGirl.create(:site)
    @loads = @site.loads
  end
  
  it "should have no :previous load if referer is NOT from within the site" do
    @loads.size.must_equal 0
    load = @loads.create FactoryGirl.attributes_for(:load, http_referer: "http://google.com/search?id=asdf")
    assert load.previous.nil?
  end
  
  it "should have a :previous load if referer IS from within the site; :previous should have :next" do
    @loads.size.must_equal 0
    uri = "http://mysite.com/"
    from = @loads.create FactoryGirl.attributes_for(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = @loads.create FactoryGirl.attributes_for(:load, http_referer: uri, uri_string: "http://mysite.com/blog/")
    
    @site.refresh_visitors
    @loads.size.must_equal 2
    loads.must_equal [from,to]
    @loads.find(to.id).previous.must_equal from
    @loads.find(from.id).next.must_equal to
  end
  
  it "should set the correct :previous load in case of multiple loads with same referer" do
    @loads.size.must_equal 0
    uri = "http://mysite.com/"
    earlier = @loads.create FactoryGirl.attributes_for(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    from = @loads.create FactoryGirl.attributes_for(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = @loads.create FactoryGirl.attributes_for(:load, http_referer: uri, uri_string: "http://mysite.com/blog/")
    
    @site.refresh_visitors
    @loads.size.must_equal 3
    loads.must_equal [earlier,from,to]
    @loads.find(to.id).previous.must_equal from
    @loads.find(from.id).next.must_equal to
  end
  
  it "should calculate time_on_page with no :previous load" do
    @loads.size.must_equal 0
    load = @loads.create FactoryGirl.attributes_for(:load, time: 30.seconds.ago)
    @loads.size.must_equal 1
    load.time_on_page.must_equal 30
  end
  
  it "should calculate time_on_page with :previous load" do
    @loads.size.must_equal 0
    uri = "http://mysite.com/"
    from = @loads.create FactoryGirl.attributes_for(:load, time: 100.seconds.ago, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = @loads.create FactoryGirl.attributes_for(:load, time: 70.seconds.ago, http_referer: uri, uri_string: "http://mysite.com/blog/")
    @site.refresh_visitors
    @loads.size.must_equal 2
    loads.must_equal [from,to]
    @loads.find(from.id).time_on_page.must_equal 30
  end
  
  def loads
    @site.visitors.first.loads.asc(:time).to_a
  end
end