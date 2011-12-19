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

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def sign_in_with_token(access_token)
    facebook_user = JSON.parse(open("https://graph.facebook.com/me?#{access_token}").read)
    user = User.find_by_facebook_id(facebook_user["id"])
    if user.nil?
      user = User.new
      user.name = facebook_user["name"]
      user.facebook_id = facebook_user["id"]
      user.email = facebook_user["email"]
      user.save
    end
   sign_in user 
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

