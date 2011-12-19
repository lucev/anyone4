class ActivitiesController < ApplicationController
#  before_filter :authenticate, :only => [:feed, :create, :destroy]
  require 'simple_time_select'
  require 'open-uri'
  require 'json'

  def feed
    if (!params[:access_token].nil? and !params[:expires].nil?)
      access_token = 'access_token='+params[:access_token]+'&expires='+params[:expires]
      current_user = sign_in_with_token access_token
    end
    
    @feed = current_user.feed
    @feed.each do |activity|
      user = User.find_by_id(activity["user_id"])
      activity["user_name"] = user.name
    end
    respond_to do |format|
      format.json {render :json => @feed}
    end
  end

  def show
    @activity = Activity.find(params[:id])
    @title = @activity.title
    @comment = Comment.new
    unless @activity.owner.friend_of? current_user or @activity.owner? current_user
      redirect_to root_path
      flash[:error] = "You don't have permission for this action"
    end
  end

  def create
      unless (params[:access_token].nil? or params[:expires].nil?)
        access_token = 'access_token='+params[:access_token]+'&expires='+params[:expires]
        current_user = sign_in_with_token access_token
      end

      @activity  = current_user.activities.build(params[:activity])

      #params from javascript calendar (calendrical)
      params[:start_date].nil? or params[:start_date].empty? ? start_date = Time.now.strftime("%m/%d/%Y") :
                                                               start_date = Date.strptime(params[:start_date], "%d/%m/%Y")
      start_time = params[:start_time]
      #params from HTML select form
      unless params[:date].nil? and params[:time].nil?
        start_date = params[:date]
        start_time = params[:time][:"time(5i)"]
      end
    @activity.starts_at = "#{start_date} #{start_time}"
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
    unless (params[:access_token].nil? or params[:expires].nil?)
      access_token = 'access_token='+params[:access_token]+'&expires='+params[:expires]
      current_user = sign_in_with_token access_token
    end  
    @activity = Activity.find_by_id(params[:activity_id])
    @activity.participants.push(current_user)
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { render :xml => @activity }
    end
  end

  def miss
    @activity = Activity.find_by_id(params[:activity_id])
    participation = @activity.participations.find_by_user_id(current_user.id)
    @activity.participations.delete(participation)
    respond_to do |format|
      format.html { redirect_to :back }
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
  
  private
  
  def sign_in_with_token(access_token)
    puts access_token
    facebook_user = JSON.parse(open("https://graph.facebook.com/me?#{access_token}").read)
      @user = User.find_by_facebook_id(facebook_user["id"])
      if @user.nil?
        @user = User.new
        @user.name = facebook_user["name"]
        @user.facebook_id = facebook_user["id"]
        @user.email = facebook_user["email"]
        @user.save
      end
    return @user
  end
end

