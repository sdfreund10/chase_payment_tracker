require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'create' do
    it 'creates a new user' do
      request = {
        'name' => 'Test Person',
        'email' => 'sample@email.com',
        'password' => 'test1234',
        'password_confirmation' => 'test1234',
      }
      expect {
        put(:create, params: { user: request })
      }.to change { User.count }.by 1
      expect(response).to have_http_status(201)
    end

    it 'does not create a new user if invalid params' do
      request = {
        'name' => 'Test Person',
        'email' => nil,
        'password' => 'test1234',
        'password_confirmation' => 'test1234',
      }
      expect {
        put(:create, params: { user: request })
      }.to change { User.count }.by 0
      expect(response).to have_http_status(422)
    end
  end
end
