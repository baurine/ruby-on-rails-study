module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def current_user?(user)
    user == current_user
  end
  
  # 退出时忘记用户
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 持久性记住用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent[:remember_token]=user.remember_token
  end
  
  # 忘记持久会话
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 重定向到之前保存的 url，或者 default url
  def redirect_back_or(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forward_url)
  end
  
  # 保存以后需要重定向的 url
  def store_location
    session[:forward_url] = request.url if request.get?
  end
end
