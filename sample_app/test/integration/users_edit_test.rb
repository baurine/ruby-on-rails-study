require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    get edit_user_path(@user)
    patch user_path(@user), user: {name: '',
                                   email: 'foobar@example.com',
                                   password: 'foo',
                                   password_confirmation: 'bar'}
    assert_template 'users/edit'
  end
end
