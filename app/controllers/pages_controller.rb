class PagesController < ApplicationController

require 'json'
require 'open-uri'

  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
      @feed_items.each do |activity|
        if activity.user.pic_square.nil?
          data = JSON.parse(open("https://graph.facebook.com/fql?q=SELECT+pic_square+FROM+user+WHERE+uid=#{activity.user.facebook_id}").read)
          activity.user.set_pic_square data['pic_square']
        end
      end
    end
  end

  def api
  @title = "API"
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

end

