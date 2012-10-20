require File.dirname(__FILE__) + "/../minitest_helper"

describe UsersController do
  
  def login(factory_symbol)
    @current_user = FactoryGirl.create(factory_symbol)
    session[:user_id] = @current_user.id
    return @current_user
  end
  
  it "must show index to admin" do
    login(:admin)
    get :index
    assert_response :success
  end
  
  it "must not show index to non-admin" do
    login(:user)
    get :index
    refute @current_user.admin?
    assert_redirected_to root_url
  end
  
  it "must not show index to not logged-in users" do
    get :index
    assert_redirected_to root_url
  end
  
  it "must show the #edit of only your own account" do
    @u1 = FactoryGirl.create(:user) 
    @u2 = login(:user2)
    
    get :edit, id: @u1.to_param   # trying to access :user's edit page
    assert_redirected_to root_url # while logged in as :user2
    
    get :edit, id: @u2.to_param   # trying to access :user2's edit page
    assert_response :success      # while logged in as :user2
  end
  
end