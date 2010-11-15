class ApplicationController < ActionController::Base
  before_filter :authenticate
  protect_from_forgery
  include SessionsHelper
  
  protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "blacknwhite" && password == "pusicamusica123"
    end
  end
end
