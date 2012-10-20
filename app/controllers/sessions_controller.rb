class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:uid => auth['uid'], :provider => auth['provider']).first
    user = User.create_with_omniauth(auth) unless user
    
    session[:user_id] = user.id
    redirect_to root_url
  end
  
  def destroy
    reset_session
    redirect_to root_url
  end
  
  def failure
    redirect_to root_url, :alert => "Unable to authenticate (#{params[:message].humanize})"
  end
  
end
