Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :creators, only: ['new', 'create', 'show', 'edit'] do
    resources :transactions, only: ['new', 'create']
  end
  get 'files/new', to: 'creators#files_new'
  get 'files/create', to: 'creators#files_create'
  resources :transactions, only: ['new', 'create', 'index', 'show']
  resources :tokens, only: ['new', 'create', 'show', 'index']
  resources :raffles, only: ['new', 'create', 'show']
end
