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

  describe 'GET user_scores' do
    before :all do
      @user1 = create(:user, id: 0, email: 'user@email.com', password: 'userpass')
      @user2 = create(:user, id: 1, email: 'user2@email.com', password: 'userpass')
      @score1 = create(:score, user: @user1, total_score: 79, played_at: '2021-05-20')
      @score2 = create(:score, user: @user2, total_score: 99, played_at: '2021-06-20')
      @score3 = create(:score, user: @user2, total_score: 68, played_at: '2021-06-13')
    end

    it 'should return an error if invalid user id' do
      get :user_scores, params: { id: 4 }
      expect(response).to have_http_status(400)
    end

    it 'should return the user and his scores if valid user id' do
      get :user_scores, params: { id: 0 }
      expect(response).to have_http_status(200)
      response_hash = JSON.parse(response.body)
      user_data = response_hash['user']
      userscores = response_hash['user_scores']
      expect(user_data['email']).to be_present
      expect(userscores.size).to eq 1
      expect(userscores[0]['id']).to eq @score1.id
      expect(@user1).to eq @score1.user
    end
  end
end
