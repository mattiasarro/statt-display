require File.dirname(__FILE__) + "/../minitest_helper"

class SiteTest < MiniTest::Rails::ActiveSupport::TestCase
  
  it "must add sites to current_user" do
    @u = FactoryGirl.create :user
    @u.sites.create(title: "asdf")
    
    @u = User.first
    @u.sites.size.must_equal 1
    @u.sites.first.users.must_include @u
  end
end
