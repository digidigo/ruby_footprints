# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ExceptionNotifiable
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => 'f1f9baf7f86a5d3957391464b0882622'
  ensure_application_is_installed_by_facebook_user
  before_filter :setup_db_facebook_user
  after_filter :publish_story_to_user
  # BEGIN setup_db_facebook_user
  def setup_db_facebook_user
    # Grab the facebook user if we have one 
    # and store it in the session
    unless( @fb_user || facebook_params.empty? )

      user_id =  facebook_params["user"]
      session_key = facebook_params["session_key"]
      expires =     facebook_params["expires"]

      fb_user = FacebookUser.ensure_create_user(user_id)   

      if( fb_user.session_key != session_key || fb_user.last_access.nil? || fb_user.last_access < (Date.today.to_time - 1 ))
        fb_user.session_key = session_key
        fb_user.session_expires = expires
        @previous_access = fb_user.last_access
        fb_user.last_access = Date.today
        fb_user.save!
      end
      @fb_user = fb_user
    end
    session[:current_user] = @fb_user
    @fb_user.facebooker_session = (@facebook_session || session[:facebook_session])
    return @fb_user
  end
  
  def publish_story_to_user
    if(@previous_access && (@previous_access < Time.parse(Date.today.to_s)) )   
      FacebookPublisher.deliver_nudge_story(current_user)
    end
  end
  
   # END setup_db_facebook_user
  def current_user
    @fb_user ||= FacebookUser.find(facebook_session.user.id)
  end
   
  # BEGIN install_url
  def application_is_not_installed_by_facebook_user
    redirect_to session[:facebook_session].install_url(:next => next_path() )
  end
  
  private
  
  def next_path

    non_keys = [ "method", "format", "_method", "auth_token"]
    url_hash = {}
    params.each do |k,v|
      next if non_keys.include?(k.to_s) || k.to_s.match(/^fb/)  
      url_hash[k] = v
    end
    url_hash[:only_path] = true
    url_hash[:canvas] = false
    url_for(url_hash)
     
  end
  
  # END install_url
  
  
end
