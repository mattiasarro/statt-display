require File.dirname(__FILE__) + "/../minitest_helper"

class LoadTest < MiniTest::Rails::ActiveSupport::TestCase
  
  it "should have no :previous load if referer is NOT from within the site" do
    Load.all.size.must_equal 0
    load = FactoryGirl.create(:load, http_referer: "http://google.com/search?id=asdf")
    assert load.previous.nil?
  end
  
  # can fail +
  it "should have a :previous load if referer IS from within the site; :previous should have :next" do
    Load.all.size.must_equal 0
    uri = "http://mysite.com/"
    from = FactoryGirl.create(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = FactoryGirl.create(:load, http_referer: uri, uri_string: "http://mysite.com/blog/")
    
    Visitor.refresh_from_loads
    Load.all.size.must_equal 2
    loads.must_equal [from,to]
    to.reload.previous.must_equal from
    from.reload.next.must_equal to
  end
  
  # can fail +
  it "should set the correct :previous load in case of multiple loads with same referer" do
    Load.all.size.must_equal 0
    uri = "http://mysite.com/"
    earlier = FactoryGirl.create(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    from = FactoryGirl.create(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = FactoryGirl.create(:load, http_referer: uri, uri_string: "http://mysite.com/blog/")
    
    Visitor.refresh_from_loads
    Load.all.size.must_equal 3
    loads.must_equal [earlier,from,to]
    to.reload.previous.must_equal from
    from.reload.next.must_equal to
  end
  
  # can fail
  it "should calculate time_on_page with no :previous load" do
    Load.all.size.must_equal 0
    load = FactoryGirl.create(:load, time: 30.seconds.ago)
    Load.all.size.must_equal 1
    load.time_on_page.must_equal 30
  end
  
  # can fail ++
  it "should calculate time_on_page with :previous load" do
    Load.all.size.must_equal 0
    uri = "http://mysite.com/"
    from = FactoryGirl.create(:load, time: 100.seconds.ago, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = FactoryGirl.create(:load, time: 70.seconds.ago, http_referer: uri, uri_string: "http://mysite.com/blog/")
    Visitor.refresh_from_loads
    Load.all.size.must_equal 2
    loads.must_equal [from,to]
    from.reload.time_on_page.must_equal 30
  end
  def loads
    Visitor.first.loads.asc(:time).to_a
  end
end