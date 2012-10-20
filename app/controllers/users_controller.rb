class UsersController < ApplicationController
  
  def index
    unless user_logged_in? and current_user.admin?
      redirect_to root_url
    end
  end
  
  def edit
    @user = User.find(params[:id])
    ensure_correct_user!
  end

end
