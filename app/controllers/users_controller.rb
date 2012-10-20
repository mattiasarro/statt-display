class UsersController < ApplicationController
  
  before_filter :correct_user?, except: :index
  
  def index
    unless user_logged_in? and current_user.admin?
      redirect_to root_url
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
end
