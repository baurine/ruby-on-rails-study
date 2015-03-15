require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @not_admin = users(:archer)
  end
  
  test "index page include pagination and delete link" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    #assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete',
                                   metheod: :delete
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@not_admin)
    end
  end
  
  test "index as not_admin" do
    log_in_as(@not_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
