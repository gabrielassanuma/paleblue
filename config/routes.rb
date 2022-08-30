Rails.application.routes.draw do
  devise_for :creators
  root to: "pages#home"
  resources :creators, only: ['new', 'create', 'show', 'edit']
  get 'files/new', to: 'creators#files_new'
  get 'files/create', to: 'creators#files_create'
  resources :transactions, only: ['new', 'create']
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
