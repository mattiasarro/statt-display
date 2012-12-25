require File.dirname(__FILE__) + "/../minitest_helper"

class UserTest < MiniTest::Rails::ActiveSupport::TestCase

  it ".admin? should behave as expected, duh" do
    @admin = FactoryGirl.create(:admin)
    assert @admin.admin?
    
    @user = FactoryGirl.create(:user)
    refute @user.admin?
  end
  
  # for the Github issue to test HABTM
  it "should have correct site_ids" do
    @user = FactoryGirl.create(:user)
    @site1 = Site.create
    @site2 = Site.create
    
    @user.site_ids = [@site1.id, @site2.id]
    @user.save
    
    @site1.reload.users.size.must_equal 1
    @site2.reload.users.size.must_equal 1
  end
  
  it "should have correct site_ids" do
    @user = FactoryGirl.create(:user)
    @user.sites.create
    @user.sites.create
    
    @user.sites.size.must_equal 2
    Site.first.users.size.must_equal 1
    Site.last.users.size.must_equal 1
  end
  
  it "should have correct site_ids" do
    @user = FactoryGirl.create(:user)
    
    @site1 = Site.create
    @site2 = Site.create
    
    @user.sites << @site1
    @user.sites << @site2
    
    @user.save
    
    @user.sites.size.must_equal 2
    @site1.reload.users.size.must_equal 1
    @site2.reload.users.size.must_equal 1
  end
  
end
