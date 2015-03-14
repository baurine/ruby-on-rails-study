class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index, :edit, :update]
  before_action :correct_user, only:[:edit, :update]
  
  def index
    @users = User.all
  end
  
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
    # @user 在 correct_user 中定义过了
    # @user = User.find(params[:id])
  end
  
  def update
    # @user 在 correct_user 中定义过了
    # @user = User.find(params[:id])
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
    
    # 事前过滤器
    # 确保已登录
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in first!"
        redirect_to login_url
      end
    end
    
    # 事前过滤器，确保是当前用户
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
