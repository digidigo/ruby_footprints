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
end
