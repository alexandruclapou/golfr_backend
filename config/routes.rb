Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'feed', to: 'scores#user_feed'
    resources :users, only: %i[show] do
      resources :scores, only: %i[index]
    end
    resources :scores, only: %i[create destroy]
  end
end
