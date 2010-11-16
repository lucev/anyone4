class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def create
    @activity  = current_user.activities.build(params[:activity])
    if @activity.save
      flash[:success] = "Activity created!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end


  def destroy
  end
end

