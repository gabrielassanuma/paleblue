Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # resources :creators, only: ['show', 'new', 'create', 'edit', 'update']
  get '/creators/:id/nfts/new', to: 'creators#nft_new', as: :creator_nfts
  post '/creators/:id/nfts/new', to: 'creators#nft_create', as: :nfts

  get 'account/:id', to: 'pages#account', as: :account

  resources :creators, only: ['new', 'create', 'show', 'edit', 'index', 'update'] do
    resources :transactions, only: ['new', 'create']
    resources :raffles, only: ['new', 'create']
  end
  post '/raffles/:id/redeem', to: 'raffles#redeem', as: :raffle_transactions
  get '/available_downloads', to: 'pages#available_downloads', as: :available_downloads
  resources :transactions, only: ['new', 'create', 'index', 'show']
  resources :tokens, only: ['new', 'create', 'show', 'index']
  resources :raffles, only: ['new', 'create', 'show', 'index']
end
