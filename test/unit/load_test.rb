require File.dirname(__FILE__) + "/../test_helper"

describe Load do
  
  it "should have no :previous load if referer is NOT from within the site" do
    load = FactoryGirl.create(:load, http_referer: "http://google.com/search?id=asdf")
    assert load.previous.nil?
  end
  
  it "should have a :previous load if referer IS from within the site; :previous should have :next" do
    uri = "http://mysite.com/"
    from = FactoryGirl.create(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = FactoryGirl.create(:load, http_referer: uri, uri_string: "http://mysite.com/blog/")
    
    Visitor.refresh_from_loads
    to.reload.previous.must_equal from
    from.reload.next.must_equal to
  end
  
  it "should set the correct :previous load in case of multiple loads with same referer" do
    uri = "http://mysite.com/"
    earlier = FactoryGirl.create(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    from = FactoryGirl.create(:load, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = FactoryGirl.create(:load, http_referer: uri, uri_string: "http://mysite.com/blog/")
    
    Visitor.refresh_from_loads
    to.reload.previous.must_equal from
    from.reload.next.must_equal to
  end
  
  it "should calculate time_on_page with no :previous load" do
    load = FactoryGirl.create(:load, time: 30.seconds.ago)
    load.time_on_page.must_equal 30
  end
  
  it "should calculate time_on_page with :previous load" do
    uri = "http://mysite.com/"
    from = FactoryGirl.create(:load, time: 100.seconds.ago, uri_string: uri, http_referer: "http://google.com/search?id=asdf")
    to   = FactoryGirl.create(:load, time: 70.seconds.ago, http_referer: uri, uri_string: "http://mysite.com/blog/")
    Visitor.refresh_from_loads
    from.reload.time_on_page.must_equal 30
  end

end