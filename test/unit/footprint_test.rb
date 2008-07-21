require File.dirname(__FILE__) + '/../test_helper'

class FootprintTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_create
     attacker = FacebookUser.create(:uid => "1")
     victim = FacebookUser.create(:uid => "2")
     
     footprint = Footprint.create(:attacker => attacker, :victim => victim)
     assert(footprint.valid?, "Footprint is not valid. What is up with that?")
  end
end
