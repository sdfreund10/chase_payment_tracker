require 'test_helper'

class CheckingAccount < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Test User", email: "sample@test.com",
                        password: "foobar", password_confirmation: "foobar")
  end

  test "saves 'CheckingAccount' in :type" do
    check = CheckingAccount.new(account_number: "1234", user: @user)
    assert(check.type == "CheckingAccount")
  end
end
