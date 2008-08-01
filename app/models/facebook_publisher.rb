
class FacebookPublisher < Facebooker::Rails::Publisher

  # BEGIN new_feed_item
  def new_footprint_feed_item_template
    one_line_story_template("{*actor*} stepped on {*target*}")
    short_story_template("{*actor*} stepped on {*target*}", "You can {*general_step_link*} on people too! With Ruby Footprints." )
    full_story_template("{*actor*} stepped on {*target*}", "{*image_link*} <p>Don't let them get away with treating each other this way.</p><p> {*call_to_action*}</p>")
  end

  def new_footprint_feed_item(footprint)
    victim = Facebooker::User.new(footprint.victim.uid)
    attacker = Facebooker::User.new(footprint.attacker.uid)
    send_as :user_action
    from(attacker)
    target_ids([victim.id])
    data({
      :general_step_link => link_to("Step", footprints_url) ,
      :image_link => link_to(image_tag("tiny-footprint.png"), footprints_url),
      :call_to_action => "Check out #{link_to("#{fb_name(victim, :possessive => true)} Ruby Footprints", new_footprint_url(:friend_to_step_on => victim.id )) } "
    })
  end
  # END new_feed_item

  # BEGIN publish_self
  def publish_self_template
    title = "{*actor*} Is a Ruby Footprint Master"
    one_line_story_template(title)
    short_story_template(title, "You can {*general_step_link*} on people too! With Ruby Footprints." )
    full_story_template(title, "{*fbml*}")
  end

  def publish_self(user)
    send_as :user_action
    from(user)
    data({
      :general_step_link => link_to("Step", footprints_url),
      :fbml => (render :partial => "/footprints/user_profile.fbml.erb", :locals => {:user => user})
    })
  end
  # END publish_self

  # BEGIN notification
  def footprint_created(footprint)
    send_as :notification
    victim = Facebooker::User.new(footprint.victim.uid)
    attacker = Facebooker::User.new(footprint.attacker.uid)
    # Note this only works during a request cycle
    # since the session is being held for us
    self.recipients(victim)
    self.from(attacker)
    fbml " stepped on you. #{link_to("See all your Ruby Footprints" , footprints_url) } "
  end
  # END notification

  # Templatized Action uses From
  # BEGIN templatized_action
  def footprint_feed_item(attacker, victim)
    send_as :templatized_action
    from(attacker)
    title_template "{actor} stepped on {target}"
    target_ids([victim.id])
    body_general("Check out #{link_to("#{fb_name(victim, :possessive => true)} Ruby Footprints", new_footprint_url(:friend_to_step_on => victim.id )) } ")
    image_1(image_path("tiny-footprint.png"))
    image_1_link(footprints_url())
  end
  # END templatized_action

  # BEGIN example_action
  def example_action(user)
    send_as :action
    from( user)
    title "just learned how to send a Mini-Feed Story using Facebooker."
    body "#{fb_name(user)} just checked out #{link_to("Ruby Footprints", footprints_url)}. A Ruby based Facebook example application."
    image_1(image_path("tiny-footprint.png"))
    image_1_link(footprints_url())
  end
  # END example_action

  # BEGIN example_story
  def nudge_story(user)
    send_as :story
    recipients(Array(user.facebooker_user))

    db_friends =  FacebookUser.find_friends(user.friends)

    if( db_friends.blank? )
      title = "None of your friends stepping on people!!"
    else
      title = db_friends[0..3].compact.collect{ |friend|
        fb_name(friend.uid)
      }.to_sentence + " have been stepping on people."
    end

    body =  "Get <a href='#{footprints_url}'> stepping </a> on your friends."

    body = body[0..200] if body.length > 200
    self.body( body )
    self.title( title )
    image_1(image_path("tiny-footprint.png"))
    image_1_link(footprints_url())
  end
  # END example_story

  # BEGIN update_profile
  def profile_for_user(user_to_update)
    send_as :profile
    from user_to_update.facebooker_user
    recipients user_to_update.facebooker_user
    fbml = render({
      :partial =>"/footprints/user_profile.fbml.erb",
      :locals => {:user => user_to_update}
    })
    profile(fbml)
    profile_main(fbml)
    action = render(:partial => "/footprints/profile_action.fbml.erb")
    profile_action(action)
  end
  # END update_profile

  # BEGIN example_profile
  def example_profile_for_user(user_to_update)
    send_as :profile
    from user_to_update
    recipients user_to_update
    fbml = render(:partial =>"/messaging/user_profile.fbml.erb")
    profile(fbml)
    action = render(:partial => "/messaging/profile_action.fbml.erb")
    profile_action(action)
  end
  # END example_profile

  # BEGIN example_email
  def example_email(from,to, title, text, html)
    send_as :email
    recipients(to)
    from(from)
    title(title)
    fbml(html)
    text(text)
  end
  # END example_email

  def logger
    RAILS_DEFAULT_LOGGER
  end
end
