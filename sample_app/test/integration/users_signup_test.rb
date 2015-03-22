require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test 'valid signup information with activation' do
    get signup_path
    name     = "example"
    email    = "user@example.com"
    password = "1234567"
    assert_difference 'User.count', 1 do
      post users_path, user: { name: name,
                                            email: email,
                                            password: password,
                                            password_confirmation: password }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 尝试在激活之前登录
    log_in_as(user)
    assert_not is_logged_in?
    # 用错误的 token 激活
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in?
    # 用错误的 email 激活
    get edit_account_activation_path(user.activation_token, email: 'wrong email')
    assert_not is_logged_in?
    # 成功激活
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not is_logged_in?
  end
end
