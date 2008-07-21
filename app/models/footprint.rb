class Footprint < ActiveRecord::Base
  belongs_to :attacker, :foreign_key => :attacker_id, :class_name => "FacebookUser"
  belongs_to :victim, :foreign_key => :victim_id, :class_name => "FacebookUser"
end
