class UsersController < InheritedResources::Base
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
    end
    
    if @user.valid?
      @user.save
      flash[:success] = "Changes saved"
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "There was a problem saving your changes"
      render :edit
    end
  end

end
