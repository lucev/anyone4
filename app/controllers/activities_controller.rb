class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]

  def show
    @activity = Activity.find(params[:id])
    @title = @activity.title
    @comment = Comment.new
  end

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

  def attend
    @activity = Activity.find_by_id(params[:activity_id])
    @activity.participants.push(current_user)
    respond_to do |format|
      format.html { redirect_to activity_path(@activity) }
      format.xml  { render :xml => @activity }
    end
  end

  def miss
    @activity = Activity.find_by_id(params[:activity_id])
    participation = @activity.participations.find_by_user_id(current_user.id)
    @activity.participations.delete(participation)
    respond_to do |format|
      format.html { redirect_to activity_path(@activity) }
      format.xml  { render :xml => @activity }
    end
  end

  def create_comment
    @comment  = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "Comment added!"
      redirect_to activity_path(params[:comment][:activity_id])
  end
  end
end

