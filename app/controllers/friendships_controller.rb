class FriendshipsController < ApplicationController
  before_filter :authenticate
  # GET /friendships
  # GET /friendships.xml
  def index
    @friendships = current_user.friendships
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @friendships }
    end
  end

  def friendship_requests
    @friendship_requests = current_user.friendship_requests
  end


  def request_friendship
    @user = User.find_by_id(params[:friendship][:friend_id])
    if (!@user.nil? and !current_user.contacts.include? @user)
      @friendship = current_user.friendships.build(:friend_id => @user.id)
      if @friendship.save
        if RAILS_ENV == 'development'
          UserMailer.friendship_request(@user, current_user).deliver
        end
        flash[:notice] = "Sent friend request."
      else
        flash[:error] = "Unable to send friend request."
      end    
    else
      flash[:notice] = "Already sent friend request"
    end
    redirect_to users_path    
  end
  
  def confirm
    @friendship = current_user.friendship_requests.find_by_id(params[:friendship_id])
    @friendship.confirmed = true
    if @friendship.save
      flash[:notice] = "Friendship confirmed"
    else
      flash[:error] = "Friendship confirmation error"
    end
    redirect_to requests_path
  end


  # DELETE /friendships/1
  # DELETE /friendships/1.xml
  def destroy
    @friendship = current_user.friendships.find_by_id(params[:id])
    if @friendship.nil?
      @friendship = current_user.reverse_friendships.find_by_id(params[:id])
    end
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to friends_path}
      format.xml  { head :ok }
    end
  end
end
