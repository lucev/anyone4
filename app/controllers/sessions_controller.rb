class SessionsController < ApplicationController

require 'open-uri'
require 'json'

  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    end
  end
  
  def fb_login
    client_id = configatron.facebook.client_id
    redirect_uri = 'http://www.anyone4.com/login/facebook'
    client_secret = ENV['FB_CLIENT_SECRET']
    unless params[:code].nil?
      fb_code = params[:code]
      token_url = "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{redirect_uri}&client_secret=#{client_secret}&code=#{fb_code}"
      access_token = open(token_url).read
      sign_in_with_token access_token   
      redirect_back_or root_path
    end
  end
  
  def accept_token
    access_token = 'access_token='+params[:access_token]+'&expires='+params[:expires]
    sign_in_with_token access_token
    redirect_to root_path   
  end
    
  def destroy
    sign_out
    redirect_to root_path
  end
  
  private
  
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

end