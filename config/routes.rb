Rails.application.routes.draw do
  devise_for :users
  resources :videos, only: [:index, :new, :create]
  get 'download_video' => 'videos#download_video'
  resources :products do
    get "delete"
  end
  get 'shoppe' => 'products#shoppe'
  root 'users#index'

  resources :conversations do
    resources :messages
  end
end
