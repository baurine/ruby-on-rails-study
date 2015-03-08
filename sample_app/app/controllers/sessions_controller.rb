class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # login ok
      log_in user
      remember user
      redirect_to user
    else
      # login failed
      # print error message
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_path
  end
end
