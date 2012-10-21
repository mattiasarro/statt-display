require File.dirname(__FILE__) + "/../minitest_helper"

describe UsersController do
  include ControllerTestHelpers
  
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
  
  it "must update the e-mail for twitter-based users" do
    @u1 = login(:user)    
    put :update, id: @u1.to_param, user: { email: "new@email.com" }
    assert_redirected_to edit_user_path(assigns(:user))
    @u1.reload.email.must_equal "new@email.com"
  end
  
  it "won't update the e-mail for non-twitter users" do
    @u1 = login(:user)
    @u1.update_attribute :provider, "twonker"
    put :update, id: @u1.to_param, user: { email: "even-newer@email.com" }
    assert_redirected_to edit_user_path(assigns(:user))
    @u1.reload.email.wont_equal "even-newer@email.com"
  end
  
end