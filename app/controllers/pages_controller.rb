class PagesController < ApplicationController

  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
      @feed_items.each do |activity|
        activity.user.get_pic_square
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

