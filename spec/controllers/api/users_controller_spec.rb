require 'rails_helper'

describe Api::UsersController, type: :controller do
  describe 'POST login' do
    before :each do
      create(:user, email: 'user@email.com', password: 'userpass')
    end

    it 'should return the token if valid username/password' do
      post :login, params: { email: 'user@email.com', password: 'userpass' }

      expect(response).to have_http_status(:ok)
      response_hash = JSON.parse(response.body)
      user_data = response_hash['user']

      expect(user_data['token']).to be_present
    end

    it 'should return an error if invalid username/password' do
      post :login, params: { email: 'invalid', password: 'user' }

      expect(response).to have_http_status(401)
    end
  end

  describe 'GET show' do
    before :all do
      @user1 = create(:user, id: 0, email: 'user@email.com', password: 'userpass')
    end

    it 'should return unauthorized if the user is not logged in' do
      get :show, params: { id: 0 }
      expect(response).to have_http_status(401)
    end

    it 'should return error if the user does not exist' do
      post :login, params: { email: 'user@email.com', password: 'userpass' }
      get :show, params: { id: 1 }
      expect(response).to have_http_status(400)
    end

    it 'should return user if the user exist and logged in' do
      post :login, params: { email: 'user@email.com', password: 'userpass' }
      get :show, params: { id: 0 }
      expect(response).to have_http_status(200)
      response_hash = JSON.parse(response.body)
      user_data = response_hash['user']
      expect(user_data['id']).to eq @user1.id
    end
  end
end
