class UserMailer < ActionMailer::Base
  default :from => "Anyone4 <no-reply@anyone4.com>"
  
  def friendship_request(user, friend)
    @user = user
    @friend = friend
    @url = "http://www.anyone4.com/friendship_requests"
    
    mail(:to => user.email, :subject => "[Anyone4] " + friend.name + " added you as friend")
  end
  
  def activity_created(user, activity_owner, activity)
    @user = user
    @activity_owner = activity_owner    
    @activity = activity
    
    mail(:to => user.email, :subject => "[Anyone4] " + activity.title)
  end
  
  def comment_created(user, comment)
    @user = user
    @comment = comment
    
    mail(:to => user.email, :subject =>"[Anyone4] " + comment.author.name + " commented activity " + 
    comment.activity.title)
  end
  
end
