require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Test User", email: "sample@test.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "name should not be blank" do
    @user.name = ""
    assert_not(@user.valid?)
  end

  test "name should be present" do
    @user.name = nil
    assert_not(@user.valid?)
  end

  test "email should not be blank" do
    @user.email = ""
    assert_not(@user.valid?)
  end

  test "email should be present" do
    @user.email = nil
    assert_not(@user.valid?)
  end

  test "email should be unique" do
    @user.save
    new_user = User.new(name: "Another One", email: @user.email)
    assert_not(new_user.valid?)
  end
end
