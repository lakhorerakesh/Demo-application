Rails.application.routes.draw do
  devise_for :users
  root 'users#index'

  resources :videos, only: [:index, :new, :create] do
    get 'download_video', on: :member
  end

  resources :products do
    get "delete"
    get 'shoppe', on: :collection
  end
  
  resources :conversations do
    resources :messages
  end

  get 'match_list' => 'users#match_list'
  get 'live_score' => 'users#live_score'
end
