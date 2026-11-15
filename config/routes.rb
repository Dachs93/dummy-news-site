Rails.application.routes.draw do
  # Redirect www.software-devs.com to the apex domain.
  constraints(host: /\Awww\./) do
    get "(*path)", to: redirect { |params, req| "#{req.protocol}#{req.host.delete_prefix('www.')}#{req.fullpath}" }, format: false
  end

  root "home#index"

  resources :articles, only: %i[ index show ]
  resources :topics, controller: "categories", only: :show, as: :categories
  resources :authors, only: :show
  get "tags/:tag", to: "articles#index", as: :tag, constraints: { tag: %r{[^/]+} }
  get "search", to: "search#index"
  get "about", to: "pages#about"
  resources :subscribers, only: :create

  get "feed", to: "feeds#show", defaults: { format: :atom }, as: :feed
  get "sitemap.xml", to: "sitemaps#show", defaults: { format: :xml }, as: :sitemap

  resource :session
  resources :passwords, param: :token

  namespace :admin do
    root "dashboard#show"
    resources :articles, except: :show do
      get :template, on: :collection
    end
    resources :categories, except: :show
    resources :authors, except: :show
    resources :subscribers, only: %i[ index destroy ]
    resources :uploads, only: %i[ index create destroy ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
