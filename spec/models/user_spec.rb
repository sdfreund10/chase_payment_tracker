require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(
      name: "Test User", email: "sample@test.com",
      password: "foobar", password_confirmation: "foobar"
    )
  end

  it "does not allow name to be blank" do
    @user.name = ""
    expect(@user.save).to eq false
  end

  it "requires name to save" do
    @user.name = nil
    expect(@user.save).to eq false
  end

  it "does not allow blank email" do
    @user.email = ""
    expect(@user.save).to eq false
  end

  it "requires email" do
    @user.email = nil
    expect(@user.save).to eq false
  end

  it "requires unique email" do
    @user.save!
    new_user = User.new(
      name: "Test", email: "sample@test.com",
      password: "foobar", password_confirmation: "foobar"
    )
    expect(new_user.save).to eq false
  end
end
