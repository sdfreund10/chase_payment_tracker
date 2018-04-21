require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'create' do
    it 'creates a new user' do
      request = {
        'name' => 'Test Person',
        'email' => 'sample@email.com',
        'password' => 'test1234',
        'password_confirmation' => 'test1234'
      }
      expect do
        put(:create, params: { user: request })
      end.to change { User.count }.by 1
      expect(response).to have_http_status(201)
    end

    it 'does not create a new user if invalid params' do
      request = {
        'name' => 'Test Person',
        'email' => nil,
        'password' => 'test1234',
        'password_confirmation' => 'test1234'
      }
      expect do
        put(:create, params: { user: request })
      end.to change { User.count }.by 0
      expect(response).to have_http_status(422)
    end
  end

  describe 'update' do
    before do
      @user = User.create(
        email: 'sample@email.com', name: 'test person',
        password: 'test1234', password_confirmation: 'test1234'
      )
      @params = {
        'name' => 'Test Person',
        'email' => 'sample@test.com',
        'password' => 'test1234',
        'password_confirmation' => 'test1234'
      }
    end

    it 'authenticates the user is an admin or has correct auth' do
      non_admin = User.create(
        email: 'nonadmin@test.com', name: 'Reg User',
        password: 'test1234', password_confirmation: 'test1234',
        is_admin: false
      )
      put :update, params: { user: @params, token: non_admin.token, id: @user.id }
      expect(response).to have_http_status(403)
      expect(@user.reload.name).not_to eq @params['name']
    end

    it 'fails if invalid token or id sent' do
      put :update, params: { user: @params, token: 'invalid_token', id: @user.id }
      expect(response).to have_http_status(400)
      expect(@user.reload.name).not_to eq @params['name']
    end

    it 'updates user if request sent by admin' do
      admin = User.create(
        email: 'admin@test.com', name: 'Admin User',
        password: 'test1234', password_confirmation: 'test1234',
        is_admin: true
      )

      put :update, params: { user: @params, token: admin.token, id: @user.id }
      expect(response).to have_http_status(200)
      expect(@user.reload.name).to eq @params['name']
    end

    it "updates account if request contains user's token" do
      put :update, params: { user: @params, token: @user.token, id: @user.id }
      expect(response).to have_http_status(200)
      expect(@user.reload.name).to eq @params['name']
    end

    it 'does not update w/ invalid params' do
      put(
        :update,
        params: { user: @params.merge('email' => nil), token: @user.token, id: @user.id }
      )
      expect(response).to have_http_status(422)
      expect(@user.reload.name).not_to eq @params['name']
    end
  end
end
