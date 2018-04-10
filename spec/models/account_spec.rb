require 'rails_helper'

RSpec.describe Account, type: :model do
  before do
  @user = User.create(
    name: "Test User", email: "sample@test.com",
    password: "foobar", password_confirmation: "foobar"
  )
  end
  it "requires account_number to save" do
    account = Account.new(user: @user, account_number: nil)
    expect(account.save).to eq false
  end

  it "requires user to save" do
    account = Account.new(user: nil, account_number: "1234")
    expect(account.save).to eq false
  end

  it "does not save if user does not exist" do
    account = Account.new(
      user_id: (User.maximum(:id) || 1) + 1,
      account_number: "1234"
    )

    expect(account.save).to eq false
  end

  it "does not create same account_number for given user" do
    Account.create!(user: @user, account_number: "1234")
    account = Account.new(user: @user, account_number: "1234")
    expect(account.save).to eq false
  end
end
