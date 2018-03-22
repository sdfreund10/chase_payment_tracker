require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "requires user" do
    ac = Account.new(account_number: "1234")
    assert_not(ac.valid?)
  end

  test "requires account_number" do
    u = User.create(name: "Test User", email: "sample@test.com",
                    password: "foobar", password_confirmation: "foobar")
    ac = Account.new(account_number: nil, user: u)
    assert_not(ac.valid?)
  end
end
