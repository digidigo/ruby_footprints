require File.dirname(__FILE__) + '/../test_helper'

class FootprintsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  
  def setup
    @user = FacebookUser.create(:uid => "1")
  end
  
  def test_index
    facebook_post 'index'
    assert assigns(:current_user_as_target_footprints)
    assert assigns(:current_user_as_source_footprints)
    assert_template 'index'
    assert_response :success
  end
  
  def test_new
    facebook_post 'new', :friend_to_step_on => 1
    assert assigns(:user_to_step_on)
    assert assigns(:user_to_step_on_as_target_footprints)
    assert assigns(:user_to_step_on_as_target_footprints)
    assert_template 'new'
    assert_response :success
  end
  
  def test_create
    assert_difference 'Footprint.count' do
      facebook_post 'create', :id => 2
    end
    assert assigns(:stepped_on_user)
    assert_facebook_redirect_to('http://apps.facebook.com/rubyfoot_test/')
  end
  
  def test_friends
    stubbed_user = stub(:friends => "1,2,3")
    Facebooker::Session.any_instance.stubs(:user).returns(stubbed_user)
    facebook_post 'friends'
    assert assigns(:friends)
  end
  
  def test_recent
    facebook_post 'recent'
    assert assigns(:footprints)
  end
end
