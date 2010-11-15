module UsersHelper

  def gravatar_for(user, options = { :size => 50 })
    gravatar_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
