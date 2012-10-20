class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :user_logged_in?
  helper_method :correct_user?
  helper_method :ensure_correct_user!

  private
  
  def current_user
    begin
      if session[:user_id]
        @current_user ||= User.find(session[:user_id]) 
      end
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def user_logged_in?
    current_user ? true : false
  end
  
  def ensure_correct_user!
    unless correct_user?
      redirect_to root_url, :alert => "You are not allowed to access that #{correct_user?.inspect}"
    end
  end
  
  def correct_user?
    user_logged_in? and @user == current_user
  end
  
  def authenticate_user!
    if !current_user
      redirect_to root_url, :alert => 'You need to log in.'
    end
  end
end
