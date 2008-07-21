# Methods added to this helper will be available to all templates in the
# application.
module ApplicationHelper
  
 def current_user
  session[:current_user]
 end
 def tab_items
  LessonOutline.outline.sections.collect do |section|

  end.join("\n")
 end

 def tab_selected?(controller_name, action_name)
  params[:controller].to_s == controller_name.to_s and params[:action].to_s == action_name.to_s
 end   

 def user_thumb(uid)
  render :partial => "/footprints/user", :locals => {:uid => uid}
 end
 
 def ajax_on?
  session[:ajaxy]
 end
end
