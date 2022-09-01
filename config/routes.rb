Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :creators, only: ['show', 'new', 'create', 'edit']
  get 'nft/new', to: 'creators#nft_new'
  post 'nft', to: 'creators#nft_create', as: :nfts


  resources :creators, only: ['new', 'create', 'show', 'edit', 'index'] do
    resources :transactions, only: ['new', 'create']
  end
  resources :transactions, only: ['new', 'create', 'index', 'show']
  resources :tokens, only: ['new', 'create', 'show', 'index']
  resources :raffles, only: ['new', 'create', 'show', 'index']
end
