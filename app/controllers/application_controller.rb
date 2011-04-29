class ApplicationController < ActionController::Base
  unless RAILS_ENV == 'development'
    before_filter :authenticate
  end
  protect_from_forgery
  include SessionsHelper

  protected
  def authenticate
    unless RAILS_ENV == 'development'
      authenticate_or_request_with_http_basic do |username, password|
        username == "blacknwhite" && password == "pusicamusica123"
      end
    end
  end
end

