require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'user is valid' do
    assert @user.valid?
  end

  test 'user is invalid if email is null' do
    @user.email = nil
    assert_not @user.valid?
  end
end
