require File.dirname(__FILE__) + "/../minitest_helper"

describe SitesController do
  include ControllerTestHelpers
  
  context "when logged in" do
    before do
      @user = login(:user)
      @site1 = @user.sites.create FactoryGirl.attributes_for(:site)
      @site2 = @user.sites.create FactoryGirl.attributes_for(:site)

      @user2 = FactoryGirl.create(:user2)
      @site2 = @user2.sites.create FactoryGirl.attributes_for(:site)
    end
    
    it "must get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:sites)
    end
    
    it "must display only your sites on index" do
      get :index
      assert_response :success
      assigns(:sites).size.must_equal 2
    end
    
    it "must get new" do
      get :new
      assert_response :success
      assert_not_nil assigns(:site)
    end

    it "must create a site" do
      assert_difference('Site.count') do
        post :create, site: @site1.attributes
      end

      assert_redirected_to site_path(assigns(:site))
    end
  end
  
  context "when not logged in" do
    before do
      @site = FactoryGirl.create(:site)
    end
    
    it "must redirect from index" do
      get :index
      assert_redirected_to root_url
    end

    it "must redirect from new" do
      get :new
      assert_redirected_to root_url
    end

    it "must redirect from create" do
      post :create, post: @site.attributes
      assert_redirected_to root_url
    end
  end
  
  context "when accessing your own site" do
    before do
      @user = login(:user)
      @site1 = @user.sites.create FactoryGirl.attributes_for(:site)
    end
    
    it "must show site" do
      get :show, id: @site1.to_param
      assert_response :success
    end

    it "must get edit" do
      get :edit, id: @site1.to_param
      assert_response :success
    end

    it "must update site" do
      put :update, id: @site1.to_param, site: @site1.attributes
      assert_redirected_to edit_site_path(assigns(:site))
    end

    it "must destroy site" do
      assert_difference('Site.count', -1) do
        delete :destroy, id: @site1.to_param
      end

      assert_redirected_to sites_path
    end
  end
  
  context "when accessing someone else's site" do
    before do
      @user = login(:user)
      @site1 = @user.sites.create FactoryGirl.attributes_for(:site)
      @site2 = @user.sites.create FactoryGirl.attributes_for(:site)

      @user2 = FactoryGirl.create(:user2)
      @site2 = @user2.sites.create FactoryGirl.attributes_for(:site)
    end
    
    it "must redirect from show" do
      get :show, id: @site2.to_param      
      assert_redirected_to root_url
    end
    
    it "must redirect from edit" do
      get :edit, id: @site2.to_param      
      assert_redirected_to root_url
    end
    
    it "must redirect from update" do
      put :update, id: @site2.to_param
      assert_redirected_to root_url      
    end
    
    it "must redirect from destroy" do
      delete :destroy, id: @site2.to_param
      assert_redirected_to root_url      
    end
  end
  
end

