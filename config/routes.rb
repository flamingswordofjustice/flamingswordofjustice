Fsj::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  root to: 'home#index'
  get  "/subscribe" => "home#subscribe", as: :subscribe
  get  "/search"    => "search#index",   as: :search
  get  "/rss"       => "home#rss",       as: :rss
  post "/ignore"    => "home#ignore",    as: :ignore

  resources :episodes do
    member do
      get 'email' => 'episodes#email', as: :email
      get 'audio' => 'episodes#audio', as: :audio
    end

    collection do
      get 'by/:category'     => 'episodes#grouped', as: :grouped
      get 'by/:category/:id' => 'episodes#index',   as: :categorized
      get ':player/:id'      => 'episodes#show',    as: :typed
      get 'latest'
      get 'rest'
    end
  end

  resources :stats,         only: [:index, :update]
  resources :redirects,     only: [:show, :index]
  resources :posts,         only: [:show, :index]
  resources :people,        only: [:show, :index]
  resources :organizations, only: [:show, :index]
  resources :topics,        only: [:show, :index]
  resources :emails,        only: [:show]

  get "/:page" => 'pages#show', as: :page
end
