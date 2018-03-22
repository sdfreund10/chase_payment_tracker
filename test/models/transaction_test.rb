require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Test User", email: "sample@test.com",
                     password: "foobar", password_confirmation: "foobar")
    @account = Account.create(user: @user, account_number: "1234")
  end

  test "should belong to account" do
    @transaction = Transaction.new(account: nil)
    assert_not(@transaction.valid?)
  end
end
