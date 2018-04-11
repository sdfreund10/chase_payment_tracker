require 'rails_helper'

RSpec.describe Transaction, type: :model do
  before do
    @user = User.create(name: "Test User", email: "sample@test.com",
                        password: "foobar", password_confirmation: "foobar")
    @account = Account.create(user: @user, account_number: "1234")
  end

  it "requires an account" do
    transaction = Transaction.new(account: nil)
    expect(transaction.save).to eq false
  end

  it "requires valid user" do
    transaction = Transaction.new(
      account_id: (Account.maximum(:id) || 1) + 1
    )

    expect(transaction.save).to eq false
  end

  it "requires unique description, account_id, posting_date, and balance" do
    Transaction.create!(
      account: @account, posting_date: 1.month.ago,
      description: "Test", balance: 100
    )

    transaction = Transaction.new(
      account: @account, posting_date: 1.month.ago,
      description: "Test", balance: 100
    )

    expect(transaction.save).to be false
  end
end
