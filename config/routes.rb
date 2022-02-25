Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'feed', to: 'scores#user_feed'
    # get 'user_scores/:id', to: 'users#user_scores'
    resources :users, only: %i[show] do
      resources :scores, only: %i[index]
      # get 'asd', to: 'scores#asd'
    end
    resources :scores, only: %i[create destroy]
  end
end
