class PagesController < ApplicationController
  def home
    @title = "Home"
    @activity = Activity.new if signed_in?
    @activities = Activity.paginate(:page => params[:page], :order => 'created_at desc')
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

end

