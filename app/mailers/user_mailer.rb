class UserMailer < ActionMailer::Base
  default :from => "Anyone4 <no-reply@anyone4.com>"
  
  def friendship_request(user, friend)
    @user = user
    @friend = friend
    @url = "http://www.anyone4.com/friendship_requests"
    
    mail(:to => user.email, :subject => "[Anyone4] " + friend.name + " added you as friend")
  end
  
end
