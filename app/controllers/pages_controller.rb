class PagesController < ApplicationController
  def home
    @title = "Home"
    @activity = Activity.new if signed_in?
    @activities = Activity.all
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

end

