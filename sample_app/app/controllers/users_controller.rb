class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    #debugger
  end
  
  def create
    @user = User.new(new_params)
    if @user.save
      puts 'save ok' # in fact should render another page
    else
      puts 'save failed'
      render 'new'
    end
  end
  
  private
    def new_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
