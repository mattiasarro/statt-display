require File.dirname(__FILE__) + "/../minitest_helper"

describe User do

  it ".admin? should behave as expected, duh" do
    @admin = FactoryGirl.create(:admin)
    assert @admin.admin?
    
    @user = FactoryGirl.create(:user)
    refute @user.admin?
  end
  
end
