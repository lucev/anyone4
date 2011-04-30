class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

end

