class UsersController < ApplicationController
  inherit_resources
  respond_to :html
  actions :update
  
  def index
    unless user_logged_in? and current_user.admin?
      redirect_to root_url
    end
  end
  
  def edit
    @user = User.find(params[:id])
    ensure_correct_user!
  end
  
  def update
    @user = User.find(params[:id])
    ensure_correct_user!
    
    if @user.provider == "twitter"
      @user.email = params[:user][:email]
      @user.save
    end
    
    redirect_to edit_user_path(@user)
  end

end
