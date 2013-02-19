Fsj::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  root to: 'home#index'
  match "/subscribe" => "home#subscribe", via: :post, as: :subscribe

  resources :episodes
  resources :posts
  resources :people
  resources :organizations

  match "/:page" => 'pages#show'
end
