class FootprintObserver < ActiveRecord::Observer
  observe Footprint
  
  def after_create(footprint)
   
    FacebookPublisher.deliver_footprint_created(footprint) rescue nil
    
   if(Facebooker::FacebookAdapter === Facebooker.current_adapter)
    FacebookPublisher.register_new_footprint_feed_item unless Facebooker::Rails::Publisher::FacebookTemplate.find_by_template_name("new_foot_print_feed_item")
    FacebookPublisher.deliver_new_footprint_feed_item(footprint )
   else
    FacebookPublisher.deliver_footprint_feed_item(footprint.attacker, footprint.victim ) rescue nil
   end
     
    FacebookPublisher.deliver_profile_for_user(footprint.attacker) rescue nil
    FacebookPublisher.deliver_profile_for_user(footprint.victim) rescue nil
  end
end
