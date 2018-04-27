require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @user = User.create(
      email: "sample@test.com", name: "test user",
      password: "test1234", password_confirmation: "test1234"
    )
  end

  describe "create" do
    it "logs in a user w/ valid params" do
      put(
        :create,
        params: { session: { email: @user.email, password: @user.password} }
      )
      expect(response).to have_http_status(200)
    end

    it "returns 422 when invalid params" do
      put(
        :create,
        params: { session: { email: @user.email, password: "something else" } }
      )
      expect(response).to have_http_status(422)
    end

    it "caches the user_id" do
      put(
        :create,
        params: { session: { email: @user.email, password: @user.password} }
      )
      expect(session[:user_id]).to eq(@user.id)
    end
  end

  describe "destroy" do
    it "removes user_id from cookie" do
      delete :destroy, params: { id: @user.id }
      expect(session[:user_id]).to be_nil
    end
  end
end
