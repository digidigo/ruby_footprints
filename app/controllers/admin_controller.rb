class AdminController < ApplicationController

   def remove_user
   end

   def invite_friends

   end

   def invited_friends
      ids = params[:ids]
      # Do something cool with the ids.
      (session[:invited_friends] ||= [] )<< ids
      session[:invited_friends] = session[:invited_friends].flatten.compact.sort.uniq
      redirect_to(friend_footprints_url(:from_invite_page => true))
   end

   def toggle_ajax
      session[:ajaxy] = (session[:ajaxy] == false)
      redirect_to(footprints_path())
   end
   
   # BEGIN publish_self
   def publish_self
      user = FacebookUser.find_by_uid(params[:fb_sig_profile_user])
      FacebookPublisher.register_publish_self unless Facebooker::Rails::Publisher::FacebookTemplate.find_by_template_name("publish_self_item")
      if wants_interface?
         render_publisher_interface(render_to_string(:partial=>"/footprints/user_profile", :locals => {:user => user}))
      else
         render_publisher_response(FacebookPublisher.create_publish_self(user))
      end
   end 
   # END publish_self
end
