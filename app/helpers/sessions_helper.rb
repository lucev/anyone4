module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
   @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end

  def current_user?(user)
    user == current_user
  end
  
  def fb_user?
    !current_user.facebook_id.nil?
  end
  
  def facebook_login_path
    'https://www.facebook.com/dialog/oauth?client_id=109791605757634&redirect_uri=http://www.anyone4.com/login/facebook&scope=email'
  end

  def authenticate
    unless signed_in?
      fb_sign_in
      redirect_to(session[:return_to])
    end
  end

  def deny_access
    store_location
    redirect_to root_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def fb_sign_in
    begin
      store_location
      redirect_to facebook_login_path
    rescue
      deny_access
    end
  end

  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

end

