require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", full_title("Sign up")
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @user, user: {name:@user.name, email:@user.email}
    assert_redirected_to login_url
  end
  
  test "should redirect edit when edit different user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_redirected_to root_url
  end
  
  test "should redirect update when update different user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: {name:@user.name, email:@user.email}
    assert_redirected_to root_url
  end

end
