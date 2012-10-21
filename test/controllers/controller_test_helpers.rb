module ControllerTestHelpers
  def login(factory_symbol)
    @current_user = FactoryGirl.create(factory_symbol)
    session[:user_id] = @current_user.id
    return @current_user
  end
end