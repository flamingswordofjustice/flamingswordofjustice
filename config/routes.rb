Fsj::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  root to: 'home#index'
  match "/subscribe" => "home#subscribe", via: :post, as: :subscribe

  resources :episodes do
    collection do
      get 'by/:category' => 'episodes#counted', as: :counted
      get 'by/:category/:id' => 'episodes#index', as: :categorized
    end
  end

  resources :posts do
  end

  resources :people
  resources :organizations

  match "/:page" => 'pages#show'
end
