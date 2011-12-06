class ApplicationController < ActionController::Base
  unless RAILS_ENV == 'development'
    before_filter :authenticate
  end
  protect_from_forgery
  include SessionsHelper
end

