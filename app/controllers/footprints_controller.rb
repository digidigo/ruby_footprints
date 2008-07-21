class FootprintsController < ApplicationController
  skip_before_filter :ensure_application_is_installed_by_facebook_user, :only => ["ajax_create","web" ]
  skip_before_filter :setup_db_facebook_user, :only => "web"
  ensure_authenticated_to_facebook :only => "ajax_create"
  def index
    @current_user_as_target_footprints = current_user.target_footprints
    @current_user_as_source_footprints = current_user.source_footprints
  end
  
  def new
    @user_to_step_on = params[:friend_to_step_on] || params[:id]
    @user_to_step_on_as_target_footprints = []
    if(user = FacebookUser.find_by_uid(@user_to_step_on) rescue nil )
      @user_to_step_on_as_target_footprints = user.footprints
    end
  end
  
  def create  
    @stepped_on_user = FacebookUser.ensure_create_user(params[:id])
    Footprint.create(:victim => @stepped_on_user, :attacker => current_user)
    #flash[:notice] = "You stepped on #{@stepped_on_user.facebooker_user.name}! "
    redirect_to(:action => "index")
  end
  
  def ajax_create
     @stepped_on_user = FacebookUser.ensure_create_user(params[:friend_to_step_on])
     footprint = Footprint.create(:victim => @stepped_on_user, :attacker => current_user)
     render :partial => "footprint", :locals => {:footprint => footprint}, :layout => false
  end
  
  def friends
    if(params[:id])
       @friends = FacebookUser.find_all_by_uid(params[:id])
    else
          @friends = FacebookUser.find_friends(facebook_session.user.friends)    
    end

  end
  
  def recent
    @footprints = Footprint.find(:all, :order => "id desc", :limit => 20)
  end
end
