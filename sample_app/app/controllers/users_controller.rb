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
      #puts 'save ok' # in fact should render another page
      #puts @user.id
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # 是因为当前类是 UsersController，所以 redirect_to 知道是重定向到 /users/id ??
      # 哦，原来这是 redirect_to user_url(@user) 的简写
    else
      #puts 'save failed'
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(new_params)
      flash[:success] = "Update profile success!"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def new_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
