require 'forwardable'

class FacebookUser < ActiveRecord::Base
 
  has_many :footprints , :foreign_key => "victim_id"
  has_many :source_footprints, :foreign_key => "attacker_id", :class_name => "Footprint"
  
  def target_footprints
    footprints
  end
  # Don't trust facebook to send a single request to you that 
  # Initiates the creation of a row in the DB
  # This code ensures that you only get one row and that you don't
  # Get an exception
  
  # BEGIN ensure_create_user
  def self.ensure_create_user(uid)
    user = nil
    begin
      user = self.find_or_initialize_by_uid(uid)
      if(user.new_record?)
        user.save!
      end
    rescue
      user = self.find_or_initialize_by_uid(uid)
      if(user.new_record?)
        user.save!
      end
    end
    raise "DidntCreateFBUser" unless user  
    return user
  end  
  # END ensure_create_user
  
  
  # Support to make the our model FacebookUser delegate to the Facebooker::User

  attr_accessor :facebooker_user
  # BEGIN facebooker_user
  def facebooker_user
    @facebooker_user ||= facebooker_session.user
  end
  # END facebooker_user
  
  attr_accessor :facebooker_session
  
  # BEGIN facebooker_session
  def facebooker_session
    unless(@facebooker_session)
      @facebooker_session = Facebooker::Session.create(ENV['FACEBOOK_API_KEY'], ENV['FACEBOOK_SECRET_KEY'])
      @facebooker_session.secure_with!(self.session_key,self.uid,0) 
      @facebooker_session.user.uid = self.uid
    end
    @facebooker_session
  end
  # END facebooker_session
  
  # BEGIN method_missing
  def method_missing(symbol , *args)
    begin
      value = super  
    rescue NoMethodError => err
      if(facebooker_user.respond_to?(symbol))    
        value = facebooker_user.send(symbol,*args)         
        return value
      else
        throw err
      end    
    end
  end
  # END method_missing
  
  def self.find_friends(friends)
    self.find(:all, :conditions => ["uid in (?)", friends.map(&:id)], :include => :footprints)
  end
  
end
